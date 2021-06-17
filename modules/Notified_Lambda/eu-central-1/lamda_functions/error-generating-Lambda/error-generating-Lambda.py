import logging
import os

logging.basicConfig(level=logging.DEBUG)
logger=logging.getLogger(__name__)


def lambda_handler(event, context):
    logger.setLevel(logging.DEBUG)
    logger.debug("This is a sample DEBUG message.. !!")
    logger.error("This is a sample ERROR message.... !!")
    logger.info("This is a sample INFO message.. !!")
    logger.critical("This is a sample 5xx error message.. !!")