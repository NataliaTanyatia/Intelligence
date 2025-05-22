"""
Hybrid Architecture Processor
"""
import multiprocessing
from functools import partial
from .fallback_mechanisms import FallbackHandler

class HybridExecutor:
    def __init__(self, max_workers=None):
        self.cpu_count = multiprocessing.cpu_count()
        self.max_workers = max_workers or self.cpu_count * 2
        self.fallback = FallbackHandler()
        
    def execute(self, func, data, mode='auto'):
        """
        Execute function across available architectures
        Modes: 'sequential', 'threaded', 'gpu', 'hybrid', 'auto'
        """
        if mode == 'auto':
            mode = self._detect_optimal_mode(func, data)
            
        return getattr(self, f'_execute_{mode}')(func, data)
    
    def _execute_sequential(self, func, data):
        try:
            return [func(d) for d in data]
        except Exception as e:
            return self.fallback.handle(e, func, data, 'sequential')
    def _execute_threaded(self, func, data):
        with ThreadPoolExecutor(max_workers=self.max_workers) as executor:
            try:
                return list(executor.map(func, data))
            except Exception as e:
                return self.fallback.handle(e, func, data, 'threaded')
    
    def _execute_gpu(self, func, data):
        from .gpu_handlers import GPUExecutor
        return GPUExecutor(self.fallback).execute(func, data)
    
    def _execute_hybrid(self, func, data):
        cpu_part, gpu_part = self._partition_data(data)
        
        cpu_result = self._execute_threaded(func, cpu_part)
        gpu_result = self._execute_gpu(func, gpu_part)
        
        return self._recombine_results(cpu_result, gpu_result, data.shape)
    
    def _detect_optimal_mode(self, func, data):
        data_size = data.size if hasattr(data, 'size') else len(data)
        if data_size < 1e4:
            return 'sequential'
        elif hasattr(data, '__cuda_array_interface__'):
            return 'gpu'
        elif data_size > 1e6:
            return 'hybrid'
        return 'threaded'
