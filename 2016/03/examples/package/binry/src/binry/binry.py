# -*- coding: utf-8 -*-

import click

@click.command()
@click.argument('decimal',nargs=1,type=click.INT)
def bin(decimal):
    """Simple progam that convert decimal to binary"""
    click.echo( "{0:b}".format(decimal) )

if __name__ == '__main__':
    bin()
