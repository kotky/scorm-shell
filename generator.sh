#!/usr/bin/env bash

PASSING_GRADE=0.8

read -p 'Access key (full url) [None]: ' ACCESS_KEY
read -p 'Course ID (just id) [None]: ' COURSE_ID
read -p 'Course Title (import display name) [None]: ' COURSE_TITLE
read -p 'Passing grade [0.8]: ' PASSING_GRADE_INPUT
if [ -n "$PASSING_GRADE_INPUT" ]; then
    PASSING_GRADE=$PASSING_GRADE_INPUT
fi
while [[ $# -gt 1 ]]
do
key="$1"

case $key in
    -ak|--access-key)
    ACCESS_KEY="$2"
    shift # past argument
    ;;
    -id|--course-id)
    COURSE_ID="$2"
    shift # past argument
    ;;
    -gr|--passing-grade)
    PASSING_GRADE="$2"
    shift # past argument
    ;;
    -ct|--course-title)
    COURSE_TITLE="$2"
    shift # past argument
    ;;
    --default)
    DEFAULT=YES
    ;;
    *)
            # unknown option
    ;;
esac
shift # past argument or value
done

> template/config/config.js
cat <<EOT >> template/config/config.js
access_key = "$ACCESS_KEY";
course_id = "$COURSE_ID";
passing_grade = $PASSING_GRADE;
EOT

rm template/imsmanifest.xml
COURSE_TITLE_FORMATTED=$(printf %q "$COURSE_TITLE")
sed -e 's/{{TITLE_PLACEHOLDER}}/'"${COURSE_TITLE_FORMATTED}"'/g' imsmanifest.xml > template/imsmanifest.xml

cd template
zip -r ../shells/"${COURSE_TITLE}".zip *
cd ../

echo "===== INPUT DATA ====="
echo "Access key: $ACCESS_KEY"
echo "Course ID: $COURSE_ID"
echo "Course Title: $COURSE_TITLE"
echo "Passing grade: $PASSING_GRADE"
echo "======================"
