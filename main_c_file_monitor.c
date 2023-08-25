#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/inotify.h>

#define EVENT_SIZE (sizeof(struct inotify_event))
#define BUF_LEN (1024 * (EVENT_SIZE + 16))


char buffer[BUF_LEN];
int length, i = 0;

// File descriptor for inotify
int fd = -1;
// Watch descriptor for inotify
int wd = -1;


//  file_path = "/path/to/watched/file"
// extern int file_monitor_init( char * file_path ) 
// extern int file_monitor_file_as_changed( ) 
// extern int file_monitor_rm_watch( )


//  file_path = "/path/to/watched/file"
extern int file_monitor_init( char * file_path ) {
    /* int */ fd = inotify_init();
    if (fd < 0) {
        perror("inotify_init");
        return -1;
    }

    /* int */ wd = inotify_add_watch(fd, file_path, IN_MODIFY);
    return fd;
}

extern int file_monitor_file_as_changed( ) {
    i = 0; // jnc: reset the index
    length = read(fd, buffer, BUF_LEN);
    int flag_modified = 0;
//    while (* i < length && flag_not_return == 1) {
        struct inotify_event *event = (struct inotify_event *) &buffer[i];
        if (event->len) {
            if (event->mask & IN_MODIFY) {
                printf("File %s was modified.\n", event->name);
                flag_modified = 1; 
            }
        }
        i += EVENT_SIZE + event->len;
//  }

    return flag_modified;
}

extern int file_monitor_rm_watch( ) {
    inotify_rm_watch( fd, wd );
    close( fd );
    return 1;
}


/*
int main() {
    char buffer[BUF_LEN];
    int length, i = 0;

    int fd = inotify_init();
    if (fd < 0) {
        perror("inotify_init");
    }

    int wd = inotify_add_watch(fd, "/path/to/watched/file", IN_MODIFY);

    length = read(fd, buffer, BUF_LEN);
    while (i < length) {
        struct inotify_event *event = (struct inotify_event *) &buffer[i];
        if (event->len) {
            if (event->mask & IN_MODIFY) {
                printf("File %s was modified.\n", event->name);
            }
        }
        i += EVENT_SIZE + event->len;
    }

    inotify_rm_watch(fd, wd);
    close(fd);
    return 0;
}
*/