"""
Graceful Degradation System
"""
import logging
from time import sleep
from typing import Callable, Any

class FallbackHandler:
    def __init__(self):
        self.logger = logging.getLogger('fallback')
        self.attempts = 3
        self.delay = 0.5
        
    def handle(self, error: Exception, func: Callable, data: Any, mode: str) -> Any:
        for i in range(self.attempts):
            try:
                sleep(self.delay * (i + 1))
                self.logger.warning(f"Attempt {i+1} after {error}")
                return func(data)
            except Exception as retry_error:
                error = retry_error
                
        self.logger.error(f"All attempts failed for {mode}: {error}")
        raise FallbackExhaustedError(f"Could not recover from {error}")

class FallbackExhaustedError(Exception):
    pass
