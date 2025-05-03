import os
import re
import subprocess

from libqtile.widget import Net


def get_active_interface():
    # Comando para obtener la información de la ruta predeterminada
    route_output = subprocess.check_output(["ip", "route"]).decode()

    # Busca la interfaz activa en la ruta predeterminada
    if "enp" in route_output:
        return re.search(r"dev (\S+) proto", route_output).group(1)
    elif "wlo" in route_output:
        return re.search(r"dev (\S+) proto", route_output).group(1)
    else:
        return "lo"  # Devuelve 'lo' como fallback si no hay conexión activa
