from setuptools import setup, find_packages

setup(name='binry-server',
      version='1.0',
      description='A simple binary command line tool',
      author='Tokyo NixOS Meetup',
      packages=find_packages(),
      install_requires=['click'],
      entry_points = {
          'console_scripts': [
              'binry = binry.binry:bin'
              ]
          },
     )
