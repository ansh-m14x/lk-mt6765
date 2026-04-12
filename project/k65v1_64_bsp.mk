LOCAL_DIR := $(GET_LOCAL_DIR)
TARGET := k65v1_64_bsp

# --- UPDATED FOR OPPO A31 ---
# 1. Disable Logo Support to stop the "No rule to make target" error
MTK_LOGO_SUPPORT := no
BOOT_LOGO := none

# 2. Disable Verified Boot to prevent bootloops on unsigned custom builds
MTK_SECURITY_SW_SUPPORT := no
MTK_VERIFIED_BOOT_SUPPORT := no
MTK_SEC_FASTBOOT_UNLOCK_SUPPORT := yes

# 3. Base Hardware Support
MTK_EMMC_SUPPORT = yes
MTK_MMC_COMBO_DRV = yes
MTK_EMMC_SUPPORT_OTP = yes
MTK_SMI_SUPPORT = yes
MTK_KERNEL_POWER_OFF_CHARGING = yes
DEFINES += MTK_NEW_COMBO_EMMC_SUPPORT
DEFINES += MTK_GPT_SCHEME_SUPPORT

# 4. Charger & PMU
MTK_CHARGER_NEW_ARCH := yes
MTK_CHARGER_INTERFACE := yes
# A31 uses MediaTek PMIC; setting this ensures the power rails initialize
DEFINES += MTK_MT6358_PMU 

# 5. Display (LCM)
# The generic driver (nt35695) is likely wrong. 
# Keep it empty for now to test if the bootloader initializes.
CUSTOM_LK_LCM="" 
MTK_LCM_PHYSICAL_ROTATION = 0

# 6. Debugging (Use UART for error logs)
DEBUG := 2
DEFINES += WITH_DEBUG_UART=1

# 7. System Stability
MTK_TINYSYS_SCP_SUPPORT = yes
MTK_TINYSYS_SSPM_SUPPORT = yes
MTK_LK_ENABLE_DCM = yes
MTK_MT22_MODE :=H1
MTK_PROTOCOL1_RAT_CONFIG = C/Lf/Lt/W/T/G
MTK_GOOGLE_TRUSTY_SUPPORT = no
MTK_EFUSE_WRITER_SUPPORT = no
MTK_SMC_ID_MGMT = yes
DEVELOP_STAGE = SB
