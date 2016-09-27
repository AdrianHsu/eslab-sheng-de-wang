#The following four macros should be defined.
TARGET1=thread-ex
OBJECT1=thread-ex.o
CC=gcc
LD_FLAGS= -lpthread
C_FLAGS=
# end of user configuration
all: $(TARGET1) $(TARGET2)
%.o : %.c
	$(CC) $(C_FLAGS) -c $<
.PHONY: clean
clean :
	rm -f $(OBJECT1) $(OBJECT2) $(TARGET1) $(TARGET2)
