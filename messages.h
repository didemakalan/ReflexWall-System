/*
 * messages.h — STM32 ile Linux arasındaki mesajlar
 *
 * Bu dosyayı hem STM32 firmware'i hem Linux tarafı kullanır.
 * Böylece iki taraf da mesajların içeriği konusunda her zaman aynı fikirdedir.
 *
 * Kabloya giden bir mesajın baytları:
 *   [A5][tip][uzunluk][veri ...][crc düşük][crc yüksek]
 *   A5  : mesajın başladığını gösteren sabit bayt
 *   crc : verinin yolda bozulup bozulmadığını anlamak için kontrol değeri
 */
#ifndef MESSAGES_H
#define MESSAGES_H

#include <stdint.h>

#define FRAME_START 0xA5

enum message_type {
    MSG_BUTTON_EVENT = 1,   /* STM32 -> Linux : bir butona basıldı ya da bırakıldı */
    MSG_LED_COMMAND  = 2,   /* Linux -> STM32 : bir butonun LED'ini yak / söndür   */
    MSG_VERSION      = 3    /* STM32 -> Linux : çalışan firmware'in versiyonu      */
};

/* Buton olayı. Zaman STM32'nin kendi timer'ından gelir;
   böylece tepki süresi Linux'un gecikmelerinden etkilenmez. */
struct button_event {
    uint8_t  button_id;     /* 0..9 */
    uint8_t  pressed;       /* 1 = basıldı, 0 = bırakıldı */
    uint32_t time_us;       /* STM32 açıldığından beri geçen süre (mikrosaniye) */
} __attribute__((packed));

/* LED komutu */
struct led_command {
    uint8_t led_id;         /* 0..9 */
    uint8_t brightness;     /* 0 = sönük, 255 = tam parlak */
} __attribute__((packed));

/* Firmware versiyonu: Linux bunu imajdaki versiyonla karşılaştırır,
   farklıysa STM32'yi yeniden programlar. */
struct version_info {
    uint8_t major;
    uint8_t minor;
    uint8_t patch;
} __attribute__((packed));

/* Mesajı kabloya gidecek baytlara çevirir. Yazılan bayt sayısını döner. */
int encode_message(uint8_t type, const void *data, uint8_t length, uint8_t *out);

/* Baytları tekrar mesaja çevirir.
   0: başarılı, -1: CRC tutmadı (veri bozulmuş), -2: geçersiz mesaj */
int decode_message(const uint8_t *in, int in_length,
                   uint8_t *type, void *data, uint8_t max_length);

uint16_t crc16(const uint8_t *data, int length);

#endif