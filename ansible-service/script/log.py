import os
import logging.config
import yaml

def setup_logging(default_path, default_level=logging.INFO, env_key="LOG_CFG"):
    path=default_path
    value=os.getenv(env_key,None)
    if value:
       path=value
    if os.path.exists(path):
       with open(path, "r") as f:
            config=yaml.load(f)
            logging.config.dictConfig(config)
    else:
       logging.basicConfig(level=default_level)
