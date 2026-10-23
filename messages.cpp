#include <string.h>
#include "messages.h"

/* CRC-16/CCITT: her baytı işleyerek 16 bitlik bir kontrol değeri üretir.
   Tek bir bit bile değişse sonuç farklı çıkar. */
uint16_t crc16(const uint8_t *data, int length)
{
    uint16_t crc = 0xFFFF;
    for (int i = 0; i < length; i++) {
        crc ^= (uint16_t)(data[i] << 8);
        for (int bit = 0; bit < 8; bit++) {
            if (crc & 0x8000)
                crc = (uint16_t)((crc << 1) ^ 0x1021);
            else
                crc = (uint16_t)(crc << 1);
        }
    }
    return crc;
}

int encode_message(uint8_t type, const void *data, uint8_t length, uint8_t *out)
{
    out[0] = FRAME_START;
    out[1] = type;
    out[2] = length;
    memcpy(&out[3], data, length);

    uint16_t crc = crc16(&out[1], 2 + length);   /* tip + uzunluk + veri */
    out[3 + length] = crc & 0xFF;
    out[4 + length] = crc >> 8;

    return 5 + length;
}

int decode_message(const uint8_t *in, int in_length,
                   uint8_t *type, void *data, uint8_t max_length)
{
    if (in_length < 5 || in[0] != FRAME_START)
        return -2;

    uint8_t length = in[2];
    if (length > max_length || in_length < 5 + length)
        return -2;

    uint16_t received_crc = (uint16_t)(in[3 + length] | (in[4 + length] << 8));
    if (crc16(&in[1], 2 + length) != received_crc)
        return -1;

    *type = in[1];
    memcpy(data, &in[3], length);
    return 0;
}