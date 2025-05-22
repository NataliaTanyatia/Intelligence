"""
Environment Scanner
"""
import os
import platform
import psutil
import numpy as np
from pathlib import Path

class EnvironmentScanner:
    def __init__(self, root='/'):
        self.root = Path(root)
        self.system_profile = {}
        
    def full_scan(self) -> dict:
        """Comprehensive environment analysis"""
        self.system_profile.update({
            'architecture': self._get_architecture(),
            'resources': self._get_system_resources(),
            'directory_structure': self._scan_directory_structure(),
            'python_environment': self._get_python_env()
        })
        return self.system_profile
    
    def _scan_directory_structure(self, max_depth=3) -> dict:
        """Recursive directory scan with constraint"""
        structure = {}
        for entry in self.root.iterdir():
            try:
                if entry.is_dir():
                    structure[str(entry)] = self._scan_directory_structure(entry) if max_depth > 0 else '...'
                else:
                    structure[str(entry)] = 'file'
            except PermissionError:
                structure[str(entry)] = 'restricted'
        return structure
