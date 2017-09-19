#!/bin/sh

# install dependencies
dnf -y install gcc make

cd /code/default/paxtest
make linux >/dev/null 2>/dev/null
if [ ! -f ./paxtest ]; then
  echo "Something went wrong during paxtest build."
  exit -1
fi

cd /code/default/selinux-dac-controls
gcc -g -O0 -o mmap_test mmap_test.c
if [ ! -f ./mmap_test ]; then
  echo "Something went wrong during mmap_test build."
  exit -1
fi

cd /code/default/timer-overhead
if [ ! -f ./timer-test ]; then
        make
        if [ "$?" -ne "0" ]; then
                echo "Timer-test build failed."
                exit -1
        fi
fi

cd /code/default/insert_leap_second
if [ ! -f ./leap-a-day ]; then
        gcc -o leap-a-day leap-a-day.c
        if [ "$?" -ne "0" ]; then
                echo "leap-a-day build failed."
                exit 3
        fi
fi

cd /code/default/memfd
if [ ! -f ./memfd_test ]; then
        gcc -D_FILE_OFFSET_BITS=64 -o memfd_test memfd_test.c
        if [ "$?" -ne "0" ]; then
                echo "memfd_test build failed."
                exit 3
        fi
fi

cd /code/default/mq-memory-corruption
if [ ! -f ./mq-notify ]; then
        gcc mq_notify-5.1.c -lrt -o mq-notify
        if [ "$?" -ne "0" ]; then
                echo "mq-notify build failed."
                exit 3
        fi
fi

cd /code/default/posix_timers
if [ ! -f ./posix_timers ]; then
        gcc -o posix_timers posix_timers.c -lrt
        if [ "$?" -ne "0" ]; then
                echo "posix_timers build failed."
                exit 3
        fi
fi
