#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"
echo -e "\n~~~~~ MY SALON ~~~~~\nWelcome to My Salon, how can I help you?\n"

MAIN_MENU(){
    # Show services
    SERVICES=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id")
    echo -e "$SERVICES" | while read SERVICE_ID BAR NAME
    do
        echo "$SERVICE_ID) $NAME"
    done
    # Get customer's choice
    read SERVICE_ID_SELECTED 
    VALID_SERVICE=$($PSQL "SELECT service_id FROM services WHERE service_id = $SERVICE_ID_SELECTED")
    if [[ -z $VALID_SERVICE ]]
    then
        echo "I could not find that service. What would you like today?"
        MAIN_MENU
    else
        SELECTED_SERVICE_NAME=$($PSQL "SELECT name FROM services where service_id='$SERVICE_ID_SELECTED'")
        echo "What's your phone number?"
        read CUSTOMER_PHONE
        CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
        if [[ -z $CUSTOMER_NAME ]]
        then
            read -p "I don't have a record for that phone number, what's your name?" CUSTOMER_NAME
            read -p "What time would you like your $SELECTED_SERVICE_NAME, $CUSTOMER_NAME?" SERVICE_TIME
            SAVE_CUSTOMER=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME','$CUSTOMER_PHONE')")
            NEW_CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
            SAVE_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES('$NEW_CUSTOMER_ID', '$SERVICE_ID_SELECTED', '$SERVICE_TIME')")
            echo -e "I have put you down for a $SELECTED_SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
        else
            read -p "What time would you like your $SELECTED_SERVICE_NAME, $CUSTOMER_NAME?" SERVICE_TIME
            CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
            SAVE_APPOINTMENT=$($PSQL "INSERT INTO appointments(service_id, time) VALUES('$SERVICE_ID_SELECTED', '$SERVICE_TIME')")
            echo -e "I have put you down for a $SELECTED_SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
        fi
    fi
}
MAIN_MENU