"""
Autonomous Endpoint Learning System
"""
import os
import re
import ast
import importlib
from pathlib import Path
from typing import Dict, List
import numpy as np

class EndpointScanner:
    def __init__(self, root_path='/'):
        self.root = Path(root_path)
        self.signature_patterns = {
            'flask': r'@app\.route\(["\'](.*?)["\']\)',
            'express': r'\.(get|post)\(["\'](.*?)["\']',
            'django': r'path\(["\'](.*?)["\']'
        }
        self.learned_endpoints = []

    def discover_framework(self) -> str:
        """Detect web framework using geometric signature matching"""
        framework_scores = {k: 0 for k in self.signature_patterns}
        
        for file in self.root.rglob('*.py'):
            with open(file) as f:
                content = f.read()
                for framework, pattern in self.signature_patterns.items():
                    framework_scores[framework] += len(re.findall(pattern, content))

        for file in self.root.rglob('*.js'):
            with open(file) as f:
                content = f.read()
                if 'express' in self.signature_patterns:
                    framework_scores['express'] += len(re.findall(self.signature_patterns['express'], content))

        return max(framework_scores.items(), key=lambda x: x[1])[0]

    def extract_endpoints(self) -> List[Dict]:
        """Recursive endpoint extraction with constraint validation"""
        framework = self.discover_framework()
        endpoints = []
        
        for file in self.root.rglob('*.py' if framework != 'express' else '*.js'):
            with open(file) as f:
                content = f.read()
                matches = re.finditer(self.signature_patterns[framework], content)
                
                for match in matches:
                    path = match.group(1) if framework != 'express' else match.group(2)
                    if self._validate_path_constraints(path):
                        endpoints.append({
                            'path': path,
                            'file': str(file),
                            'line': content.count('\n', 0, match.start()) + 1,
                            'methods': self._detect_methods(content, match, framework)
                        })
        
        self.learned_endpoints = self._filter_duplicates(endpoints)
        return self.learned_endpoints

    def _validate_path_constraints(self, path: str) -> bool:
        """Apply geometric constraints to path structure"""
        path_vector = np.array([ord(c) for c in path])
        return (
            len(path) > 1 and 
            np.std(path_vector) > 10 and  # Sufficient variation
            (path_vector.max() - path_vector.min()) > 32  # Adequate range
        )
