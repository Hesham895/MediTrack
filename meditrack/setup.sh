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

echo "Setup completed successfully!"