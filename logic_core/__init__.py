"""
LOGIC CORE - Theoretical Framework Implementation
Implements recursive symbolic intelligence with geometric constraint resolution
"""
from .intelligence.algorithms import SymbolicProcessor
from .interface.system_scan import EnvironmentScanner
from .utils.hybrid_processing import HybridExecutor

__version__ = "0.1.0"
__all__ = ['SymbolicProcessor', 'EnvironmentScanner', 'HybridExecutor']
