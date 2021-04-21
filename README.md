# msc-crawler
Web Crawler with ACHE for a COVID-19 QA chatbot

## ACHE
This repository contains the configurations and interaction scripts for the [ACHE](https://github.com/ViDA-NYU/ache) crawler.

## Structure
### scripts
contains interaction scripts

- **./install_ache.sh**: verifies dependencies and installs ACHE via Docker
- **./start_crawler.sh <application_name>**: starts ACHE crawler for the given application (defined in configs/<application_name>) by running a Docker container
- **./stop_crawler.sh <application_name>**: stops the Docker container running the crawler for the given application (if it is running)
- **./reset_crawler.sh <application_name>**: same as stop_crawler.sh, but also deletes the crawled data and other generated metadata.

### configs
contains ACHE specific configurations

- shoud contain a folder for each crawling application (**<application_name>**)
- each of its subfolders should contain (at least) the following files: 
  - **settings.env**, which sets the general variables for that specific application
  - **ache.yml**, which sets the ACHE configurations
  - **seeds.txt**, which lists the seed URLs
