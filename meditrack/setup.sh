#!/bin/bash

# Create migrations
echo "Creating migrations..."
python manage.py makemigrations accounts
python manage.py makemigrations patients
python manage.py makemigrations medical
python manage.py makemigrations pharmacy

# Apply migrations
echo "Applying migrations..."
python manage.py migrate

#run the server
echo "Starting the server..."       
python manage.py runserver

#setup success message
echo "Setup completed successfully!"