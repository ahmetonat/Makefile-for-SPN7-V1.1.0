# Makefile-for-SPN7-V1.1.0

ST microelectronics has a nice BLDC development board called [X-NUCLEO-IHM07M1](https://www.st.com/en/ecosystems/x-nucleo-ihm07m1.html). It provides the basic circuitry for power electronics and sensing. ST also provides a nice software library and source code called [X-CUBE-SPN7](https://www.st.com/en/embedded-software/x-cube-spn7.html) so that you can quickly start running the motor and develop applications. The base code allows motor start stop with the user button, and speed setting with the potentiometer.

Unfortunately, the example software is designed to be ran on development environments coming from companies or sources which require you to register for download. I don't like either of these choices. So we worked with students and developed a Makefile to allow [GNU Arm Embedded Toolchain](https://launchpad.net/gcc-arm-embedded) as an open source toolchain to be used for compiling SPN7 example project.

In this repo, I only provide the Makefile, but no code from SPN7 to avoid any copyright issues. SPN7 is available from ST Microelectronics as a download. In the Makefile, the location of each file used in the project is clearly stated.

To build and run this project you need:
1. Buy the hardware. Easiest is the [P-NUCLEO-IHM001](https://www.st.com/en/evaluation-tools/p-nucleo-ihm001.html) pack with power electronics, STM32F302 Nucleo board and a hobby BLDC motor.
2. Install the GCC development environment. See [my blog for installing GNU ARM Embedded Toolchain](https://aviatorahmet.blogspot.com/2016/04/arm-stm32f10x-programming-with-gcc.html). It describes STM32F103 only, but the same environment can be used for other M0~M4 cores.
3. Install the [X-CUBE-SPN7](https://www.st.com/en/embedded-software/x-cube-spn7.html) package from ST Microelectronics. Well, yes, you need to register to ST for that...
4. Download the Makefile given here. Modify the Makefile according to where you installed GNU ARM EMbedded, SPN7 etc. The provided Makefile is for Linux, so make sure you replace forward slashes in the directory names with backward slashes in Windows. The same Makefile also works in Windows (tested).
5. The path to some of the files are specified in the Makefile. The others should be copied into the project directory. Or, you can add their locations to the search path if you like.
6. That's it! 'make' and enjoy.
7. To program the target, you can use 'make jflash'. If you connect to a microcontroller without ST-LINK V2, but only a serial port, you can use 'make sflash'. (For the former, you need to have ['stlink'](https://github.com/texane/stlink)  and for the latter ['stm32flash'](https://sourceforge.net/projects/stm32flash) installed, both open source.)


[Share and enjoy!](https://www.urbandictionary.com/define.php?term=share%20and%20enjoy)
