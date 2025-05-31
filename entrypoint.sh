#!/bin/bash

# Run Gunicorn as the specified user
python3 manage.py collectstatic --noinput
python3 manage.py migrate
gunicorn -b 0.0.0.0:8000 -w 2 mypython.wsgi
