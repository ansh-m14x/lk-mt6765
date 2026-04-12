LOCAL_DIR := $(GET_LOCAL_DIR)

# Essential hardware modules required for A31 initialization
MODULES += \
	$(LOCAL_DIR)/video \
	$(LOCAL_DIR)/lcm \
	$(LOCAL_DIR)/gic \
	$(LOCAL_DIR)/md_com

OBJS += \
	$(LOCAL_DIR)/dev.o

# Commented out to fix "No rule to make target" error
# By removing this, the build system will not look for fhd_uboot.raw
# include $(LOCAL_DIR)/logo/rules.mk
