from jupyter_core.paths import jupyter_data_dir
import subprocess
import os
import errno
import stat

c = get_config()
c.NotebookApp.iopub_data_rate_limit=1.0e10
c.NotebookApp.ip = '0.0.0.0'
c.NotebookApp.port = 8888
c.NotebookApp.open_browser = False
c.NotebookApp.tornado_settings = { 'headers': { 'Content-Security-Policy': "child-src * " } }
c.NotebookApp.iopub_data_rate_limit=1.0e10
c.NotebookApp.token=''
c.NotebookApp.allow_root = True
c.NotebookApp.allow_origin = '*'
