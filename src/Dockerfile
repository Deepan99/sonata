# Use the official AWS Lambda Python image
FROM public.ecr.aws/lambda/python:3.11

# Install any system packages required for processing (e.g., Poppler for PDF)
RUN yum install -y poppler-utils && yum clean all

# Copy requirements.txt
COPY requirements.txt ${LAMBDA_TASK_ROOT}

# Install dependencies
RUN pip install -r requirements.txt

# Copy function code
COPY app.py ${LAMBDA_TASK_ROOT}

# Set the CMD to your handler
CMD [ "app.lambda_handler" ]
