# Use an official Python runtime as the base image
FROM python:3.11.3

# Set the working directory in the container
WORKDIR /app

# Copy the requirements file to the container
COPY requirements.txt .

# Install the project dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the project code to the container
COPY . .

# Run database migrations
RUN cd tf_automation_api && python manage.py makemigrations tf_automation_api && python manage.py migrate

RUN chmod -R 777 .

# Expose the port that the Django application will run on
EXPOSE 8000

# Run the Django development server
CMD ["python", "tf_automation_api/manage.py", "runserver", "0.0.0.0:8000"]