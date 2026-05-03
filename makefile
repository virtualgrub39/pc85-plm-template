ifeq ($(OS),Windows_NT)
    BINEXT := .exe
else
    BINEXT :=
endif

ASM    = ./bin/asm80$(BINEXT)
PLMC   = ./bin/plm80c$(BINEXT)
LN     = ./bin/link$(BINEXT)
LOCATE = ./bin/locate$(BINEXT)
OBJHEX = ./bin/objhex$(BINEXT)

SOURCE_DIR = src
ASM_DIR = asm
LIB_DIR = lib
OBJ_DIR = obj
OUT_DIR = out

empty :=
space := $(empty) $(empty)
comma := ,

# ==========================================
#                 RUNTIME
# ==========================================
LIB_SRC_ASM = $(ASM_DIR)/runtime.asm
LIBS        = $(LIB_DIR)/plm80.lib

# Generate Object paths for the runtime
LIB_OBJS = $(addprefix $(OBJ_DIR)/, $(notdir $(LIB_SRC_ASM:.asm=.asm.obj)))

# ==========================================
#                PROGRAMS
# ==========================================
# Define your applications here
PROGRAMS = hello

hello_SRC_PLM = $(SOURCE_DIR)/hello.plm
hello_SRC_ASM = 

PROGRAM_HEXES = $(addprefix $(OUT_DIR)/, $(addsuffix .hex, $(PROGRAMS)))

# ==========================================
#             BUILD TARGETS
# ==========================================
all: $(PROGRAM_HEXES)

$(OBJ_DIR) $(OUT_DIR):
	mkdir -p $@

$(OBJ_DIR)/%.plm.obj: $(SOURCE_DIR)/%.plm | $(OBJ_DIR)
	$(PLMC) $< 'OBJECT($@)' 'PRINT($(OBJ_DIR)/$*.plm.lst)'

$(OBJ_DIR)/%.asm.obj: $(ASM_DIR)/%.asm | $(OBJ_DIR)
	$(ASM) $< 'OBJECT($@)' 'PRINT($(OBJ_DIR)/$*.asm.lst)'

# ==========================================
#             PROGRAM TEMPLATE 
# ==========================================
define PROGRAM_template
$(1)_OBJS = $$(addprefix $$(OBJ_DIR)/, $$(notdir $$($(1)_SRC_PLM:.plm=.plm.obj))) \
            $$(addprefix $$(OBJ_DIR)/, $$(notdir $$($(1)_SRC_ASM:.asm=.asm.obj)))

# Link
$$(OBJ_DIR)/$(1).obj: $$($(1)_OBJS) $$(LIB_OBJS) $$(LIBS) | $$(OBJ_DIR)
	$$(LN) $$(subst $$(space),$$(comma),$$(strip $$^)) TO $$@

# Locate: Apps live in RAM. 
# 2000H-200FH is reserved for runtime ENTRY. App code starts at 2010H.
$$(OBJ_DIR)/$(1).abs: $$(OBJ_DIR)/$(1).obj
	$$(LOCATE) $$< TO $$@ 'CODE(2010H)' 'DATA(3500H)' 'STACK(3FFFH)'

# Hex
$$(OUT_DIR)/$(1).hex: $$(OBJ_DIR)/$(1).abs | $$(OUT_DIR)
	$$(OBJHEX) $$< TO $$@
endef

$(foreach prog,$(PROGRAMS),$(eval $(call PROGRAM_template,$(prog))))

clean:
	$(RM) -r $(OBJ_DIR) $(OUT_DIR)
	$(RM) *.hex *.obj *.abs *.lst *.map

.PHONY: all clean
