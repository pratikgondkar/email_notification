TASK_FILE="task.txt"
LOG_FILE="task_log.txt"
EMAIL="pratikgondkar4040@gmail.com"
TASK_NAME=$1
TASK_PATH=$2


submit_task() {
    echo "Enter Task Name:"
    read TASK_NAME
    echo "Enter Path of Task Script:"
    read TASK_PATH
    echo "Enter Task Type (Manual/Scheduled):"
    read TASK_TYPE
    CRON_EXPR=""
    if [ "$TASK_TYPE" == "Scheduled" ]; then
        echo "Enter Cron Expression:"
        read CRON_EXPR
    fi
    echo "$TASK_NAME|$TASK_PATH|$TASK_TYPE|$CRON_EXPR" >> $TASK_FILE
    echo "Task $TASK_NAME submitted successfully!"
}
list_tasks() {
    awk -F'|' '{print $1}' task.txt 
}
run_task() {
    bash $TASK_PATH
    if [ $? -eq 0 ]; then
        echo "$TASK_NAME executed successfully at $(date)" >> $LOG_FILE
        echo "Task $TASK_NAME executed successfully" | mail -s "Task Success" $EMAIL
    else
        echo "$TASK_NAME execution failed at $(date)" >> $LOG_FILE
        echo "Task $TASK_NAME execution failed" | mail -s "Task Failure" $EMAIL
    fi
}
delete_task() {
         echo "Deleting task entry for $TASK_NAME..."
         sed -i "/$TASK_NAME/d" /home/pratik/task.txt
         echo "Deleted task entry for $TASK_NAME."
 }
 task_history() {
    grep "$TASK_NAME" task_log.txt
 }


while getopts "ale::d:h:" opt; do
    case $opt in
        a)
            option="1"
            ;;
        l)
            option="2"
            ;;
        e)
            option="3";TASK_NAME="$OPTARG";TASK_PATH="$OPTARG"
            ;;
        d)
            option="4";TASK_NAME="$OPTARG"
            ;;
        h)
            option="5";TASK_NAME="$OPTARG"
            ;;
    esac
done

    

case $option in
        1)
            submit_task
            ;;
        2)
            list_tasks
            ;;
        3)
            run_task
            ;;
        4)
            delete_task
            ;;
        5)
            task_history
            ;;
        *)
            echo "Invalid option, please try again."
            ;;
    esac

