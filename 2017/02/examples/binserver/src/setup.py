from setuptools import setup, find_packages

setup(name='binserver',
      version='1.0',
      description='A simple rest binary service',
      author='Tokyo NixOS Meetup',
      packages=find_packages(),
      install_requires=['flask'],
      entry_points = {
          'console_scripts': [
              'binserver = app.binserver:run_server'
              ]
          },
     )
