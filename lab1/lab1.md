#  LAB1 結報（20160923）
---
* **嵌入式系統實驗（EE3021）**
* 姓名：許秉鈞  
* 學號：B03901023  
* 系級：電機三  
* **指導教授：Prof. Sheng-De Wang**  
* **實驗助教：楊鈞皓**
  
---
# Lab 1-1

## 實驗目的
創造兩個threads，印出對應的id與其data，並觀察自己與其他users各自的process status。

## 實驗結果
	user@ta-MS-AA52:~/Desktop/lab1$ ./thread-ex 
	Thread 2 (thread id: 140593401870080) says Hi! 
	PID: 7526
	Thread 1 (thread id: 140593401870080) says Hello! 
	PID: 7526
（每次測試時，Thread 2 和 Thread 1出現的順序不一定相同）  
在另一個TERMINAL，輸入指令`ps -eLf | grep thread-ex` ：


	user@ta-MS-AA52:~/Desktop/lab1$ ps -eLf | grep thread-ex
	user      7526  5596  7526  0    3 15:44 pts/0    00:00:00 ./thread-ex
	user      7526  5596  7527  0    3 15:44 pts/0    00:00:00 ./thread-ex
	user      7526  5596  7528  0    3 15:44 pts/0    00:00:00 ./thread-ex
	user      7530  7490  7530  0    1 15:44 pts/8    00:00:00 grep --color=auto thread-ex



## 觀察討論

### Why execute the shell command in another terminal?  `ps -eLf | grep thread-ex`

	-e: 印出其他user的processes
	-L: 挑出特定keyword  
	-f: 印出uid, pid, parent pid, recent CPU usage, process start time, controlling tty, 
	elapsed CPU usage, and the associated command.
對照關係為：

	UID    PID  PPID   LWP  C NLWP STIME   TTY        TIME         CMD
	user  7526  5596  7528  0    3 15:44 pts/0    00:00:00 ./thread-ex
	
ref: [https://kb.iu.edu/d/afnv](https://kb.iu.edu/d/afnv)

在另一個terminal執行`ps`的原因，是為了檢查user UID是否有變化。`BLABLABLA| grep thread-ex`則是為了將前面的輸出，grep出含有`thread-ex`的行，其他都捨棄掉，所以才需要加上Pipe後面那串。
### What is the purpose of the command? Note the PID, LWP and NLWP fields> LWP: Light Weight Process (LWP is the thread id)

`7526`一欄為pid, `5596`一欄為ppid, 後面的`7526`一欄為LWP。  
這個指令的目的，是為了檢查`uid`, `pid`以及`parent pid`是否有變化。從結果中看出，除了`grep`指令，`pid`, `ppid`, `NLWP`均同、但`LWP`不一樣。原因是因為`7526`, `7527`代表不同的thread id。`NLWP`代表的是目前有幾個threads，因此數量為3（不包含`PID=7530`那一行）。

### Explain the organization of a Makefile

`makefile`

	#The following four macros should be defined.
	TARGET1=thread-ex
	OBJECT1=thread-ex.o
	CC=gcc
	LD_FLAGS= -lpthread
	C_FLAGS=
	# end of user configuration
	all: $(TARGET1)
	%.o : %.c
		$(CC) $(C_FLAGS) -c $< # 真正跑的cmd是這行，其他都是代號
	.PHONY: clean # PHONY代表 偽目標，也就是這些檔案若存在，就clean；不存在也沒關係，因為本來就是偽的。
	clean :
		rm -f $(OBJECT1) $(OBJECT2)

首先，我已經把`TARGET2, OBJECT2, g++, CXX_FLAGS`都移除，因為這次用C語言寫、不需要管`g++`。  
`LD_FLAGS`加上 -lpthread 告訴它要去連結 libpthread，但這次程式不需要，因此在輸出object時我只使用`C_FLAGS`。

### What are the main concepts behind in make mechanisms?
把每個指令打包成一鍵搞定，以處理大型、但編譯或link形式相似的程式。

---
# Lab 1-2

## 實驗目的
利用`strace`追蹤特定的system calls，並找出第一個被用到的sys call。

## 實驗結果
	
	
	user@ta-MS-AA52:~/Desktop/lab1$ strace cat /proc/cpuinfo
	execve("/bin/cat", ["cat", "/proc/cpuinfo"], [/* 69 vars */]) = 0
	brk(0)                                  = 0x9b3000
	access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
	mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f339df4e000
	access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
	open("/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
	fstat(3, {st_mode=S_IFREG|0644, st_size=79008, ...}) = 0
	mmap(NULL, 79008, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7f339df3a000
	close(3)                                = 0
	access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
	open("/lib/x86_64-linux-gnu/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
	read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\320\37\2\0\0\0\0\0"..., 832) = 832
	fstat(3, {st_mode=S_IFREG|0755, st_size=1840928, ...}) = 0
	mmap(NULL, 3949248, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f339d969000
	mprotect(0x7f339db24000, 2093056, PROT_NONE) = 0
	mmap(0x7f339dd23000, 24576, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x1ba000) = 0x7f339dd23000
	mmap(0x7f339dd29000, 17088, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7f339dd29000
	close(3)                                = 0
	mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f339df39000
	mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f339df37000
	arch_prctl(ARCH_SET_FS, 0x7f339df37740) = 0
	mprotect(0x7f339dd23000, 16384, PROT_READ) = 0
	mprotect(0x60a000, 4096, PROT_READ)     = 0
	mprotect(0x7f339df50000, 4096, PROT_READ) = 0
	munmap(0x7f339df3a000, 79008)           = 0
	brk(0)                                  = 0x9b3000
	brk(0x9d4000)                           = 0x9d4000
	open("/usr/lib/locale/locale-archive", O_RDONLY|O_CLOEXEC) = 3
	fstat(3, {st_mode=S_IFREG|0644, st_size=7220496, ...}) = 0
	mmap(NULL, 7220496, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7f339d286000
	close(3)                                = 0
	fstat(1, {st_mode=S_IFCHR|0620, st_rdev=makedev(136, 8), ...}) = 0
	open("/proc/cpuinfo", O_RDONLY)         = 3
	fstat(3, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
	fadvise64(3, 0, 0, POSIX_FADV_SEQUENTIAL) = 0
	read(3, "processor\t: 0\nvendor_id\t: Genuin"..., 65536) = 3652
	write(1, "processor\t: 0\nvendor_id\t: Genuin"..., 3652processor	: 0
	vendor_id	: GenuineIntel
	cpu family	: 6
	model		: 42
	model name	: Intel(R) Core(TM) i3-2100 CPU @ 3.10GHz
	stepping	: 7
	microcode	: 0xd
	cpu MHz		: 1610.183
	cache size	: 3072 KB
	physical id	: 0
	siblings	: 4
	core id		: 0
	cpu cores	: 2
	apicid		: 0
	initial apicid	: 0
	fpu		: yes
	fpu_exception	: yes
	cpuid level	: 13
	wp		: yes
	flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 popcnt tsc_deadline_timer xsave avx lahf_lm arat epb pln pts dtherm tpr_shadow vnmi flexpriority ept vpid xsaveopt
	bugs		:
	bogomips	: 6185.55
	clflush size	: 64
	cache_alignment	: 64
	address sizes	: 36 bits physical, 48 bits virtual
	power management:
	
	processor	: 1
	vendor_id	: GenuineIntel
	cpu family	: 6
	model		: 42
	model name	: Intel(R) Core(TM) i3-2100 CPU @ 3.10GHz
	stepping	: 7
	microcode	: 0xd
	cpu MHz		: 1614.906
	cache size	: 3072 KB
	physical id	: 0
	siblings	: 4
	core id		: 1
	cpu cores	: 2
	apicid		: 2
	initial apicid	: 2
	fpu		: yes
	fpu_exception	: yes
	cpuid level	: 13
	wp		: yes
	flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 popcnt tsc_deadline_timer xsave avx lahf_lm arat epb pln pts dtherm tpr_shadow vnmi flexpriority ept vpid xsaveopt
	bugs		:
	bogomips	: 6185.55
	clflush size	: 64
	cache_alignment	: 64
	address sizes	: 36 bits physical, 48 bits virtual
	power management:
	
	processor	: 2
	vendor_id	: GenuineIntel
	cpu family	: 6
	model		: 42
	model name	: Intel(R) Core(TM) i3-2100 CPU @ 3.10GHz
	stepping	: 7
	microcode	: 0xd
	cpu MHz		: 1640.093
	cache size	: 3072 KB
	physical id	: 0
	siblings	: 4
	core id		: 0
	cpu cores	: 2
	apicid		: 1
	initial apicid	: 1
	fpu		: yes
	fpu_exception	: yes
	cpuid level	: 13
	wp		: yes
	flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 popcnt tsc_deadline_timer xsave avx lahf_lm arat epb pln pts dtherm tpr_shadow vnmi flexpriority ept vpid xsaveopt
	bugs		:
	bogomips	: 6185.55
	clflush size	: 64
	cache_alignment	: 64
	address sizes	: 36 bits physical, 48 bits virtual
	power management:
	
	processor	: 3
	vendor_id	: GenuineIntel
	cpu family	: 6
	model		: 42
	model name	: Intel(R) Core(TM) i3-2100 CPU @ 3.10GHz
	stepping	: 7
	microcode	: 0xd
	cpu MHz		: 1609.214
	cache size	: 3072 KB
	physical id	: 0
	siblings	: 4
	core id		: 1
	cpu cores	: 2
	apicid		: 3
	initial apicid	: 3
	fpu		: yes
	fpu_exception	: yes
	cpuid level	: 13
	wp		: yes
	flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 popcnt tsc_deadline_timer xsave avx lahf_lm arat epb pln pts dtherm tpr_shadow vnmi flexpriority ept vpid xsaveopt
	bugs		:
	bogomips	: 6185.55
	clflush size	: 64
	cache_alignment	: 64
	address sizes	: 36 bits physical, 48 bits virtual
	power management:
	
	) = 3652
	read(3, "", 65536)                      = 0
	close(3)                                = 0
	close(1)                                = 0
	close(2)                                = 0
	exit_group(0)                           = ?
	+++ exited with 0 +++

## 觀察討論

### What is the first system call used?
其實就是第一行：
`	execve("/bin/cat", ["cat", "/proc/cpuinfo"], [/* 69 vars */]) = 0
`

---
# Lab 1-3

## 實驗目的
利用socket sys calls，創造一個server、不斷傳遞`date`, `time`這些data，只要任一個client連上線的時候，就接收那個server給的data。
## 實驗結果
	user@ta-MS-AA52:~/Desktop/lab1/lab1-2$ ./time_serv &
在另一個TERMINAL： 

	user@ta-MS-AA52:~/Desktop/lab1/lab1-2$ ./time_client 192.168.1.170
	Fri Sep 23 16:23:44 2016
	user@ta-MS-AA52:~/Desktop/lab1/lab1-2$ ./time_client 192.168.1.194
	Fri Sep 23 16:23:56 2016

## 觀察討論

***socket***：某個system的`"IP address"` + `"port"`、是這個system跟其他system溝通的end point。  
***4-tuple***：兩個sys分別跑不同的兩筆processes，他們倆之間的connection可以被一個4-tuple唯一決定。


***socket一共有3個參數***

	   serv_addr.sin_family = AF_INET;
	   serv_addr.sin_addr.s_addr = htonl(INADDR_ANY);
	   serv_addr.sin_port = htons(5000); 

* arg(1): socket descriptor, 一個整數，代表socket已被建立(`AF_INET`)
* arg(2): SOCK_STREAM, 代表用哪一個transport layer protocol
* arg(3): 當0 by default，代表TCP for default protocol

***server依序做的function calls***
   
	bind(listenfd, (struct sockaddr*)&serv_addr, sizeof(serv_addr)); 
	listen(listenfd, 10); 
   
* bind(): 就把server的資訊丟進他自己的socket  
* listen(): e.g. 吃arg = 10代表最多接待10個client

-

	while(1)
	{
	  connfd = accept(listenfd, (struct sockaddr*)NULL, NULL); 
	  ticks = time(NULL);
	  snprintf(sendBuff, sizeof(sendBuff), "%.24s\r\n", ctime(&ticks));
	  write(connfd, sendBuff, strlen(sendBuff)); 
	  close(connfd);
	  sleep(1);
	}
	

  
* accept(): server一般時候sleep, 在client request時會回傳socket   descriptor並達成3 way TCP handshake  
* write(): 當server收到client的request時，server透過socket_descriptor，在client 的socket上寫入data。
* close(): 停止傳data

***client依序做的function calls***

	if((sockfd = socket(AF_INET, SOCK_STREAM, 0)) < 0){blabla}

* socket(): 建構子的概念

-
   
	if( connect(sockfd, (struct sockaddr *)&serv_addr, sizeof(serv_addr)) < 0) {blabla}

* connect(): 兩端socket連接（此時，還沒將我們的client socket 給bind到特定的port上）

-
	
	while ( (n = read(sockfd, recvBuff, sizeof(recvBuff)-1)) > 0){blabla}

* 兩人的sockets連上時，server會送出data，在client socket上跑
* 遇到socket descriptor 時，client可以用normal read call，在自己的socket descriptor上read出所求的data
