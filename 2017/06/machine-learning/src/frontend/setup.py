from setuptools import setup, find_packages

setup(name='cnn-mnist',
      version='1.0',
      description='Digit recognition web application.',
      include_package_data=True,
      packages=find_packages(),
      install_requires=[ 'flask' ],
      entry_points = {
          'console_scripts': [
              'cnn-mnist=app.cnn_mnist:run_server'
              ]
          },
     )
