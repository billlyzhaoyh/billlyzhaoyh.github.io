---
title: "PEP 810 in Python 3.15 brings lazy import functionality"
date: 2025-11-06
tags: [Python, Tips]
excerpt: "PEP 810 introduces explicit lazy imports to Python 3.15, allowing you to defer module loading until first use with new syntax"
---

Came across this new feature announcement on my LinkedIn feed and I ask Claude to summarise and explained it to me via the website https://peps.python.org/pep-0810/

![Lazy import json demo](/assets/images/lazy-import-python.jpeg)

---
## Claude summary:

### Key Benefits

**Performance improvements:**
- **50-70% faster startup** for CLI tools
- **30-40% memory savings** in large applications
- Zero overhead after first use (adaptive interpreter optimization)

**Use cases:**
- Command-line tools that load many modules but only use a few based on user input
- Type-only imports (eliminates need for `TYPE_CHECKING` guards)
- Large applications with heavy dependency graphs

### How It Works

**Before lazy imports:**
```python
import json  # Module loads immediately, even if never used
print("App started")
# json already in memory
```

**With lazy imports:**
```python
lazy import json  # Creates a proxy, module NOT loaded yet
print("App started")  # Fast startup
result = json.dumps({})  # NOW json loads on first use
```

### Practical Examples

**1. CLI Tools with Subcommands**
```python
# Without lazy imports - ALL modules load even for --help
import argparse
import requests
import pandas
import matplotlib
# User just wanted --help but waited for everything!

# With lazy imports - only load what's needed
import argparse
lazy import requests  # Only if API command used
lazy import pandas    # Only if data command used
lazy import matplotlib # Only if plot command used
```

**2. Type Annotations (No More TYPE_CHECKING blocks!)**
```python
# Old way - verbose
from typing import TYPE_CHECKING
if TYPE_CHECKING:
    from collections.abc import Sequence, Mapping

# New way - clean!
lazy from collections.abc import Sequence, Mapping
def process(items: Sequence[str]) -> Mapping[str, int]:
    ...  # No runtime cost for these imports
```

**3. Moving Inline Imports to Top**
```python
# Before - scattered imports hurt readability
def process_data(data):
    import json  # Repeatedly resolved!
    return json.dumps(data)

# After - clear dependencies, no repeated overhead
lazy import json  
def process_data(data):
    return json.dumps(data)  # Loads once on first call
```

### Control Mechanisms

**1. Explicit keyword (recommended):**
```python
lazy import expensive_module
```

**2. Backward-compatible declaration:**
```python
__lazy_modules__ = ["json", "requests"]  # Works on 3.15+, ignored on older
import json  # Treated as lazy on 3.15+
```

**3. Global mode (advanced):**
```bash
python -X lazy_imports=enabled script.py  # All imports become lazy
```

**4. Filter function (fine-grained control):**
```python
def my_filter(importer, name, fromlist):
    # Exclude modules with side effects
    if name in {'legacy_plugin', 'metrics_collector'}:
        return False  # Force eager
    return True  # Allow lazy

sys.set_lazy_imports_filter(my_filter)
```

### Important Gotchas

**⚠️ Import-time side effects are deferred:**
```python
# BAD: Plugin registration on import
@register_plugin("MyPlugin")  # Won't run until first use!
class MyPlugin: pass

# GOOD: Explicit discovery
def discover_plugins():
    from my_plugin import MyPlugin
    register_plugin(MyPlugin)
```

**⚠️ Errors appear at first use, not at import:**
```python
lazy import broken_module
print("Import succeeded")  # Doesn't fail yet
broken_module.foo()  # ImportError raised HERE
```

**⚠️ Star imports can't be lazy:**
```python
lazy from module import *  # SyntaxError!
```

### Is This Useful?

**Yes, if you have:**
- CLI tools where startup time matters (help pages, simple commands)
- Large applications loading hundreds of modules
- Many type-only imports cluttering your code with `TYPE_CHECKING` blocks
- Performance-critical initialization paths

**Maybe not needed if:**
- Your program is a long-running service where startup time doesn't matter
- You have few dependencies
- All your imports are actually used during initialization

### Adoption Strategy

Start small and measure:
1. Profile your app to find slow imports
2. Add `lazy` to annotation-only imports (easy win)
3. Mark heavy modules that aren't always used
4. Test for side-effect issues
5. Expand usage based on results

The beauty is it's **completely opt-in** - existing code works unchanged, and you can adopt it incrementally where it helps most.

