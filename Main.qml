import QtQuick

Window {
    id: window
    width: 1280
    height: 720
    visible: true
    title: "Reflex Wall"
    color: "#101820"

    // Şu an gösterilen slaytın sırası
    property int current: 0

    // Slaytlar: her biri bir başlık, isteğe bağlı alt başlık ve satırlardan oluşur
    property var slides: [
        {
            title: "Design and Implementation of a Custom Yocto-Based Embedded Linux Kiosk Platform",
            subtitle: "COME 361 Operating Systems - Term Project Proposal - 23.10.2026",
            bullets: false,
            lines: [
                "Şevket Eren Kaynar - 202303001137",
                "Mert Azat Söğüt - 202303001132",
                "Didem Akalan - 202203001038"
            ]
        },
        {
            title: "Problem and Motivation",
            subtitle: "",
            bullets: true,
            lines: [
                "General-purpose Linux distributions are built for desktops and servers, not for unattended kiosk devices.",
                "A kiosk needs a fast, seamless boot and a single supervised application with no desktop environment.",
                "It must survive sudden power loss, handle time-critical input and report its status remotely.",
                "We study how these requirements are met at the operating system level by building our own Linux distribution with Yocto."
            ]
        },
        {
            title: "Objective and Main Outcome",
            subtitle: "",
            bullets: true,
            lines: [
                "A working kiosk device running a custom Yocto-built Linux image on a Raspberry Pi CM0-based custom board.",
                "Seamless splash screen from the kernel to the application.",
                "A Qt application started and supervised by systemd.",
                "An I/O daemon talking to the application over Unix domain sockets, and an STM32 programmed from Linux.",
                "Read-only root filesystem and LTE-based telemetry.",
                "Reference application: a reaction-time game with 10 buttons and a display."
            ]
        },
        {
            title: "Related Operating System Concepts",
            subtitle: "",
            bullets: true,
            lines: [
                "Process and Thread Management: systemd supervision, restart and watchdog",
                "Concurrency and Synchronization: I/O daemon serving multiple clients",
                "Processor Scheduling: stock kernel vs. PREEMPT_RT input latency",
                "File Systems and Storage: read-only root filesystem, power-loss robustness",
                "Inter-Process Communication: Unix domain sockets between the I/O daemon and the UI",
                "I/O and Drivers: device tree, GPIO, UART, display (DRM/KMS)"
            ]
        },
        {
            title: "Technical Infrastructure",
            subtitle: "",
            bullets: true,
            lines: [
                "Platform: Yocto Project (Poky) for Raspberry Pi CM0, development on Raspberry Pi Zero 2 W",
                "Languages: C, C++ / QML, BitBake / Shell",
                "Libraries: Qt 6, POSIX sockets, libgpiod, libsystemd, ModemManager, STM32 HAL",
                "Repository: github.com/sqayner/yocto-embedded-kiosk-project-come361"
            ]
        },
        {
            title: "Task Distribution",
            subtitle: "",
            bullets: true,
            lines: [
                "Şevket Eren Kaynar (202303001137): Platform - Yocto image, boot and splash screen, custom PCB",
                "Didem Akalan (202203001038): Application layer - Qt user interface and telemetry",
                "Mert Azat Söğüt (202303001132): I/O layer - STM32 firmware and I/O daemon",
                "Measurements: boot time (Şevket), memory usage (Didem), input latency (Mert)"
            ]
        },
        {
            title: "Progress So Far",
            subtitle: "",
            bullets: true,
            lines: [
                "Şevket: Yocto project and custom layer set up, splash screen tested, Qt application built with Yocto and started by a systemd service, PCB design started.",
                "Didem: Qt Quick application started, a sample user interface developed and tested.",
                "Mert: Suitable STM32 researched, first experiments done on an STM32 Blue Pill board."
            ]
        },
        {
            title: "Next Deliverables",
            subtitle: "",
            bullets: true,
            lines: [
                "Şevket: reduce the splash screen delay, make the boot transition seamless, finalize the PCB design.",
                "Didem: integrate the STM32 communication layer into the Qt application.",
                "Mert: implement STM32 - CM0 messaging (UART or SPI) and button input handling."
            ]
        },
        {
            title: "Thank You",
            subtitle: "Questions?",
            bullets: false,
            lines: []
        }
    ]

    function next() {
        if (current < slides.length - 1)
            current = current + 1
    }

    function previous() {
        if (current > 0)
            current = current - 1
    }

    Item {
        anchors.fill: parent
        focus: true

        Keys.onRightPressed: window.next()
        Keys.onSpacePressed: window.next()
        Keys.onLeftPressed: window.previous()
        Keys.onEscapePressed: Qt.quit()

        // Fareyle tıklayınca sonraki slayt
        MouseArea {
            anchors.fill: parent

            acceptedButtons: Qt.LeftButton | Qt.RightButton
            onClicked: (mouse) => {
                    if (mouse.button === Qt.LeftButton) {
                        window.next()
                    } else if (mouse.button === Qt.RightButton) {
                        window.previous()
                    }
                }
        }

        // Üst bar
        Rectangle {
            id: topBar
            width: parent.width
            height: 60
            color: "#1B2735"

            Text {
                text: "Reflex Wall"
                color: "white"
                font.pixelSize: 24
                font.bold: true
                anchors.left: parent.left
                anchors.leftMargin: 30
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                text: "COME 361 Operating Systems"
                color: "#9AA5B1"
                font.pixelSize: 16
                anchors.right: parent.right
                anchors.rightMargin: 30
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        // Slayt içeriği
        Column {
            anchors.top: topBar.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 60
            spacing: 24

            Text {
                width: parent.width
                text: window.slides[window.current].title
                color: "#4FC3F7"
                font.pixelSize: 40
                font.bold: true
                wrapMode: Text.WordWrap
            }

            Text {
                width: parent.width
                text: window.slides[window.current].subtitle
                visible: text !== ""
                color: "#9AA5B1"
                font.pixelSize: 22
                wrapMode: Text.WordWrap
            }

            Repeater {
                model: window.slides[window.current].lines

                Text {
                    width: parent.width
                    text: (window.slides[window.current].bullets ? "•  " : "") + modelData
                    color: "white"
                    font.pixelSize: 24
                    wrapMode: Text.WordWrap
                }
            }
        }

        // Alt bar
        Text {
            text: "← →  to navigate"
            color: "#5C6B7A"
            font.pixelSize: 14
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.margins: 20
        }

        Text {
            text: (window.current + 1) + " / " + window.slides.length
            color: "#9AA5B1"
            font.pixelSize: 16
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: 20
        }
    }
}