#The following macros should be defined.
TARGET1=use_gdb
OBJECT1=use_gdb.o
OBJECT2=
AS=as
AS_FLAGS=-gstabs
CC=gcc
CXX=g++
LD=ld
LD_FLAGS =
C_FLAGS=
# end of user configuration
#
ALL : $(TARGET1)
$(TARGET1) : $(OBJECT1) $(OBJECT2)
	$(LD)  $^ $(LD_FLAGS) -o $@
%.o : %.s
	$(AS) $(AS_FLAGS) $<  -o $@
%.o : %.c
	$(CC) $(C_FLAGS) -c $<
%.o : %.cpp
	$(CXX) $(C_FLAGS) -c $<
.PHONY: clean
clean :
	-rm -f $(OBJECT1) $(OBJECT2)