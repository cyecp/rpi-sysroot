��    M      �  g   �      �  Q  �  `   �	  b   <
  0   �
  p   �
  k   A  #   �     �     �       )     	   E  3   O     �  �   �      .  ,   O  $   |     �      �     �     �  #     !   :     \     p  <   �  <   �  %         )     J     i     �     �     �     �     �     �  �     &   �     �          *  �   A  d   $     �  $   �  u   �  C   ;  =        �  &   �     �  )        8  H   R  (   �  E  �  �   
  �  �  .   o  F   �  "   �  -        6  
   V     a     t     {     �     �     �     �     �     �     �  �  �    �  �   �#  �   �$  _   S%  �   �%  �   �&  7   �'  +   �'  1   (  %   3(  p   Y(     �(  ]   �(  E   ?)  �   �)  Y   *  [   �*  M   5+  .   �+  <   �+  6   �+  >   &,  H   e,  W   �,  I   -  T   P-  <   �-  <   �-  %   .      E.  =   f.  F   �.  &   �.  )   /  4   </  #   q/  ,   �/  .   �/    �/  M   1      R1  8   s1  ;   �1  �  �1  �   i3  )   74  4   a4  �   �4  [   E5  q   �5  ,   6  C   @6  I   �6  D   �6  9   7  �   M7  I   �7  i  18  U  �:  "  �;  g   B  q   |B  B   �B  �   1C  @   �C     D     8D  !   KD     mD     �D     �D     �D     �D     �D     �D  
   �D     '          @   :       I      K      <   
   D   F   B   H      2      -   3   /                  ;      )                9   4               ?   0       *   M   =          C       ,            L   %                     #      5           7   G      	   E           (       +   !                   1   $       "   J             &          >   A                     6   .      8           killall -l, --list
       killall -V, --version

  -e,--exact          require exact match for very long names
  -I,--ignore-case    case insensitive process name match
  -g,--process-group  kill process group instead of process
  -y,--younger-than   kill processes younger than TIME
  -o,--older-than     kill processes older than TIME
  -i,--interactive    ask for confirmation before killing
  -l,--list           list all known signal names
  -q,--quiet          don't print complaints
  -r,--regexp         interpret NAME as an extended regular expression
  -s,--signal SIGNAL  send this signal instead of SIGTERM
  -u,--user USER      kill only process(es) running as USER
  -v,--verbose        report if the signal was successfully sent
  -V,--version        display version information
  -w,--wait           wait for processes to die
   -                     reset options

  udp/tcp names: [local_port][,[rmt_host][,[rmt_port]]]

   -4,--ipv4             search IPv4 sockets only
  -6,--ipv6             search IPv6 sockets only
   -Z     show         SELinux security contexts
   -Z,--context REGEXP kill only process(es) having context
                      (must precede other arguments)
   PID    start at this PID; default is 1 (init)
  USER   show only trees rooted at processes of this user

 %*s USER        PID ACCESS COMMAND
 %s is empty (not mounted ?)
 %s: Invalid option %s
 %s: no process found
 %s: unknown signal; %s -l lists signals.
 (unknown) /proc is not mounted, cannot stat /proc/self/stat.
 Bad regular expression: %s
 CPU Times
  This Process    (user system guest blkio): %6.2f %6.2f %6.2f %6.2f
  Child processes (user system guest):       %6.2f %6.2f %6.2f
 Can't get terminal capabilities
 Cannot allocate memory for matched proc: %s
 Cannot find socket's device number.
 Cannot find user %s
 Cannot open /proc directory: %s
 Cannot open /proc/net/unix: %s
 Cannot open a network socket.
 Cannot open protocol file "%s": %s
 Cannot resolve local port %s: %s
 Cannot stat %s: %s
 Cannot stat file %s: %s
 Copyright (C) 1993-2009 Werner Almesberger and Craig Small

 Copyright (C) 1993-2010 Werner Almesberger and Craig Small

 Copyright (C) 2007 Trent Waddington

 Copyright (C) 2009 Craig Small

 Could not kill process %d: %s
 Error attaching to pid %i
 Invalid namespace name Invalid option Invalid time format Kill %s(%s%d) ? (y/N)  Kill process %d ? (y/N)  Killed %s(%s%d) with signal %d
 Memory
  Vsize:       %-10s
  RSS:         %-10s 		 RSS Limit: %s
  Code Start:  %#-10lx		 Code Stop:  %#-10lx
  Stack Start: %#-10lx
  Stack Pointer (ESP): %#10lx	 Inst Pointer (EIP): %#10lx
 Namespace option requires an argument. No process specification given No processes found.
 No such user name: %s
 PSmisc comes with ABSOLUTELY NO WARRANTY.
This is free software, and you are welcome to redistribute it under
the terms of the GNU General Public License.
For more information about these matters, see the files named COPYING.
 Page Faults
  This Process    (minor major): %8lu  %8lu
  Child Processes (minor major): %8lu  %8lu
 Press return to close
 Process with pid %d does not exist.
 Process, Group and Session IDs
  Process ID: %d		  Parent ID: %d
    Group ID: %d		 Session ID: %d
  T Group ID: %d

 Process: %-14s		State: %c (%s)
  CPU#:  %-3d		TTY: %s	Threads: %ld
 Scheduling
  Policy: %s
  Nice:   %ld 		 RT Priority: %ld %s
 Signal %s(%s%d) ? (y/N)  Specified filename %s does not exist.
 TERM is not set
 Unable to open stat file for pid %d (%s)
 Unknown local port AF %d
 Usage: killall [-Z CONTEXT] [-u USER] [ -eIgiqrvw ] [ -SIGNAL ] NAME...
 Usage: killall [OPTION]... [--] NAME...
 Usage: peekfd [-8] [-n] [-c] [-d] [-V] [-h] <pid> [<fd> ..]
    -8 output 8 bit clean streams.
    -n don't display read/write from fd headers.
    -c peek at any new child processes too.
    -d remove duplicate read/writes from the output.
    -V prints version info.
    -h prints this help.

  Press CTRL-C to end output.
 Usage: prtstat [options] PID ...
       prtstat -V
Print information about a process
    -r,--raw       Raw display of information
    -V,--version   Display version information and exit
 Usage: pstree [ -a ] [ -c ] [ -h | -H PID ] [ -l ] [ -n ] [ -p ] [ -g ] [ -u ]
              [ -A | -G | -U ] [ PID | USER ]
       pstree -V
Display a tree of processes.

  -a, --arguments     show command line arguments
  -A, --ascii         use ASCII line drawing characters
  -c, --compact       don't compact identical subtrees
  -h, --highlight-all highlight current process and its ancestors
  -H PID,
  --highlight-pid=PID highlight this process and its ancestors
  -g, --show-pgids    show process group ids; implies -c
  -G, --vt100         use VT100 line drawing characters
  -l, --long          don't truncate long lines
  -n, --numeric-sort  sort output by PID
  -p, --show-pids     show PIDs; implies -c
  -s, --show-parents  show parents of the selected process
  -u, --uid-changes   show uid transitions
  -U, --unicode       use UTF-8 (Unicode) line drawing characters
  -V, --version       display version information
 You can only use files with mountpoint options You cannot search for only IPv4 and only IPv6 sockets at the same time You must provide at least one PID. all option cannot be used with silent option. asprintf in print_stat failed.
 disk sleep fuser (PSmisc) %s
 paging peekfd (PSmisc) %s
 prtstat (PSmisc) %s
 pstree (PSmisc) %s
 running sleeping traced unknown zombie Project-Id-Version: psmisc 22.17rc1
Report-Msgid-Bugs-To: csmall@small.dropbear.id.au
POT-Creation-Date: 2012-06-21 21:57+1000
PO-Revision-Date: 2012-05-21 21:20+0400
Last-Translator: Yuri Kozlov <yuray@komyakino.ru>
Language-Team: Russian <gnu@mx.ru>
Language: ru
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Generator: Lokalize 1.2
Plural-Forms:  nplurals=3; plural=(n%10==1 && n%100!=11 ? 0 : n%10>=2 && n%10<=4 && (n%100<10 || n%100>=20) ? 1 : 2);
        killall -l, --list
       killall -V, --version

  -e,--exact           требовать полного совпадения для очень длинных имён
  -I,--ignore-case     игнорировать регистр символов в именах процессов
  -g,--process-group   завершать группу процесса вместо одного процесса
  -y,--younger-than    завершить процессы, новее чем заданного ВРЕМЕНИ
  -o,--older-than      завершить процессы, старее чем заданного ВРЕМЕНИ
  -i,--interactive     запрашивать подтверждение перед завершением процессов
  -l,--list            вывести список допустимых имён сигналов
  -q,--quiet           не показывать подробные сообщения
  -r,--regexp          рассматривать ИМЯ как расширенное регулярное выражение
  -s,--signal СИГНАЛ   посылать указанный СИГНАЛ, а не SIGTERM
  -u,--user ПОЛЬЗВ      завершить процесс(ы), запущенный только ПОЛЬЗОВАТЕЛЕМ
  -v,--verbose         уведомлять только при успешной отправке сигнала
  -V,--version         показать информацию о версии
  -w,--wait            ожидать завершения процессов
     -                  отменить предыдущие параметры

  Имена udp/tcp: [локальный_порт][,[удалённый_узел][,[удалённый_порт]]]

     -4,--ipv4          поиск только среди сокетов IPv4
    -6,--ipv6          поиск только среди сокетов IPv6
   -Z     show         показывать контексты безопасности SELinux
   -Z,--context РЕГВЫР  завершать только процессы(ы) с подходящим контекстом
                       (должен указываться раньше остальных параметров)

   PID                 начинать от указанного PID; по умолчанию 1 (init)
  ПОЛЬЗОВАТЕЛЬ        показать только дерево процессов указанного пользователя

 %*s ПОЛЬЗ-ЛЬ    PID ДОСТУП КОМАНДА
 %s пуст (не смонтирован?)
 %s: неправильный параметр %s
 %s: процесс не найден
 %s: неизвестный сигнал; %s -l выводит список доступных сигналов.
 (неизвестно) /proc не смонтирован, возможно выполнить stat /proc/self/stat.
 Неправильное регулярное выражение: %s
 Процессорное время
  Этот процесс      (польз. систем. гостевое blkio): %6.2f %6.2f %6.2f %6.2f
  Дочерние процессы (польз. систем. гостевое):       %6.2f %6.2f %6.2f
 Не удалось определить характеристики терминала
 Не удалось выделить память для проверяемого proc: %s
 Не удалось найти номер устройства сокета.
 Пользователь %s не найден
 Не удалось открыть каталог /proc: %s
 Не удалось открыть /proc/net/unix: %s
 Не удалось открыть сетевой сокет.
 Не удалось открыть файл протокола "%s": %s
 Не удалось определить имя локального порта %s: %s
 Не удалось выполнить функцию stat для %s: %s
 Не удалось выполнить функцию stat для файла %s: %s
 Copyright (C) 1993-2009 Werner Almesberger and Craig Small

 Copyright (C) 1993-2010 Werner Almesberger and Craig Small

 Copyright (C) 2007 Trent Waddington

 Copyright (C) 2009 Craig Small

 Не удалось завершить процесс %d: %s
 Ошибка присоединения к процессу с pid %i
 Неверное имя области неправильный параметр неправильный формат времени Завершить %s(%s%d)? (y/N)  Завершить процесс %d? (y/N)  %s(%s%d) завершён сигналом %d
 Память
  Vsize:        %-10s
  RSS:          %-10s 		 Предел RSS: %s
  Начало кода:  %#-10lx		 Конец кода:  %#-10lx
  Начало стека: %#-10lx
  Указатель стека (ESP): %#10lx	 Указатель инстр. (EIP): %#10lx
 Для параметра области требуется значение. Не указан процесс Не найдено ни одного процесса.
 Неизвестное имя пользователя: %s
 PSmisc поставляется БЕЗ КАКИХ-ЛИБО ГАРАНТИЙ.
Это свободная программа; вы можете распространять её на условиях
Универсальной общественной лицензии GNU.
Подробная информация об этих условиях приведена в файле COPYING.
 Страничные отказы
  Этот процесс      (первичный вторичный): %8lu  %8lu
  Дочерние процессы (первичный вторичный): %8lu  %8lu
 Нажмите Enter для выхода
 Процесс с pid %d не существует.
 ID процесса, группы и сеанса
  ID процесса: %d		  ID родителя: %d
    ID группы: %d		 ID сеанса: %d
  ID T-группы: %d

 Процесс: %-14s		Состояние: %c (%s)
  ЦП#:  %-3d		TTY: %s	Нитей: %ld
 Планировка
  Политика:     %s
  Уступчивость: %ld 		 Приоритет RT: %ld %s
 Послать сигнал %s(%s%d)? (y/N)  Указанное имя файла %s не существует.
 Переменная окружения TERM не установлена
 Не удалось открыть файл stat для pid %d (%s)
 Неизвестный локальный порт AF %d
 Использование: killall [-Z КОНТЕКСТ] [-u ПОЛЬЗОВАТЕЛЬ]
                       [ -eIgiqrvw ] [ -СИГНАЛ ] ИМЯ…
 Использование: killall [ПАРАМЕТР]… [--] ИМЯ…
 Использование: peekfd [-8] [-n] [-c] [-d] [-V] [-h] <pid> [<fd> ..]
    -8 в потоках не сбрасывается 8-й бит.
    -n не отображать fd заголовки при чтении/записи.
    -c наблюдать также за всеми новыми дочерними процессами.
    -d удалять повторяющиеся операции чтения/записи при выводе.
    -V вывести информацию о версии.
    -h вывести эту справку.

  Нажмите CTRL-C для завершения.
 Использование: prtstat [параметры] PID …
       prtstat -V
Выводит информацию о процессе
    -r,--raw       вывести информацию в необработанном виде
    -V,--version   вывести информацию о версии и закончить работу
 Использование: pstree [ -a ] [ -c ] [ -h | -H PID ] [ -l ] [ -n ] [ -p ]
              [ -g ] [ -u ] [ -A | -G | -U ] [ PID | ПОЛЬЗОВАТЕЛЬ ]
       pstree -V
Показывает дерево процессов.

  -a, --arguments     показывать аргументы командной строки
  -A, --ascii         использовать ASCII-символы для рисования линий
  -c, --compact       не сжимать одинаковые поддеревья
  -h, --highlight-all выделять цветом текущий процесс и его предков
  -H PID,
  --highlight-pid=PID выделить цветом процесс PID и его предков
  -g, --show-pgids    показывать идентификаторы групп процесса;
                      включает -c
  -G, --vt100         использовать символы терминала VT100 для рисования линий
  -l, --long          не обрезать длинные строки
  -n, --numeric-sort  сортировать вывод по PID
  -p, --show-pids     показывать идентификаторы процессов (PID); включает -c
  -u, --uid-changes   показывать переходы идентификаторов пользователей
  -U, --unicode       использовать символы UTF-8 (юникод) для рисования линий
  -V, --version       показать информацию о версии
 Вы можете использовать файлы только с параметрами mountpoint Нельзя выполнять поиск только по сокетам IPv4 и IPv6 одновременно Вы должны указать не менее одного PID. Параметр показа всех файлов нельзя использовать вместе с параметром отключения сообщений. asprintf в print_stat завершилась неудачно.
 спит из-за диска fuser (PSmisc) %s
 замещает страницы peekfd (PSmisc) %s
 prtstat (PSmisc) %s
 pstree (PSmisc) %s
 работает спит трассируется неизвестно зомби 