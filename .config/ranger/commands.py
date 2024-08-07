import os
import subprocess

from ranger.api.commands import Command
from ranger.container.file import File
from ranger.core.loader import CommandLoader

class meld_diff(Command):
    """
    Hace un diff con Meld entre dos archivos o directorios seleccionados.
    """

    def execute(self):
        files = self.fm.thistab.get_selection()
        if len(files) != 2:
            self.fm.notify("Selecciona exactamente dos archivos o directorios para hacer el diff.")
            return

        file1 = files[0].path
        file2 = files[1].path

        # Verificar si son directorios
        if os.path.isdir(file1) and os.path.isdir(file2):
            # Comparar directorios
            self.fm.run(["meld", file1, file2])
        else:
            # Comparar archivos (código original)
            self.fm.run(["meld", file1, file2])

class meld_diff_files(Command):
    """
    Hace un diff con Meld entre dos archivos o directorios seleccionados.
    """

    def execute(self):
        if self.fm.thisfile.is_directory:
            self.fm.notify("No se puede hacer diff de directorios con Meld.")
            return

        # Obtener los archivos seleccionados
        files = self.fm.thistab.get_selection()
        if len(files) != 2:
            self.fm.notify("Selecciona exactamente dos archivos para hacer el diff.")
            return

        # Obtener las rutas de los archivos
        file1 = files[0].path
        file2 = files[1].path

        # Ejecutar el comando Meld
        self.fm.run(["meld", file1, file2])

class dumpput(Command):
    """dump put"""

    def execute(self):
        selection = [
            os.path.basename(file.path) for file in self.fm.thistab.get_selection()
        ]
        if not selection:
            return
        for selected_entry in selection:
            command = "dump --put --recursive '%s'" % selected_entry
            dump_process = self.fm.execute_command(
                command, universal_newlines=True, stdout=subprocess.PIPE
            )
            stdout, stderr = dump_process.communicate()
            if stderr:
                self.fm.notify(stderr.rstrip("\n"))
            else:
                self.fm.notify(stdout.rstrip("\n"))


class dumpregret(Command):
    """dump regret"""

    def execute(self):
        command = "dump --undo"
        dump_process = self.fm.execute_command(
            command, universal_newlines=True, stdout=subprocess.PIPE
        )
        stdout, stderr = dump_process.communicate()
        if stderr:
            self.fm.notify(stderr.rstrip("\n"))
        else:
            self.fm.notify(stdout.rstrip("\n"))


class dumpclean(Command):
    """dump clean"""

    def execute(self):
        command = "dump --clean"
        dump_process = self.fm.execute_command(
            command, universal_newlines=True, stdout=subprocess.PIPE
        )
        stdout, stderr = dump_process.communicate()
        if stderr:
            self.fm.notify(stderr.rstrip("\n"))
        else:
            self.fm.notify(stdout.rstrip("\n"))


class fbookmark(Command):
    """fbookmark ranger integration"""

    def execute(self):
        bookmark = self.fm.execute_command(
            "exebookmark", universal_newlines=True, stdout=subprocess.PIPE
        )
        stdout, _ = bookmark.communicate()
        dir_path = stdout.rstrip("\n")
        if dir_path and os.path.isdir(dir_path):
            self.fm.cd(dir_path)


class fzfind(Command):
    """
    Busca archivos recursivamente desde el directorio actual y los abre en Geany.
    Muestra una vista previa de los archivos con sintaxis coloreada utilizando bat.
    """

    def execute(self):
        if self.fm.settings["show_hidden"]:
            hidden_flag = "-H"
        else:
            hidden_flag = ""

        # fzf_cmd = f"fd -t f {hidden_flag} --strip-cwd-prefix | fzf +m --preview 'head -n 50 {{}}'"  # Vista previa con head
        fzf_cmd = f"fd -t f {hidden_flag} --strip-cwd-prefix | fzf +m --preview 'bat --style=numbers --color=always  {{}}'"

        try:
            fzf = self.fm.execute_command(
                fzf_cmd, universal_newlines=True, stdout=subprocess.PIPE
            )
            stdout, _ = fzf.communicate()

            if fzf.returncode == 0:
                results = stdout.rstrip("\n").splitlines()
                for result in results:
                    result = os.path.abspath(result)
                    if os.path.isdir(result):
                        self.fm.cd(result)
                    elif os.path.isfile(result):
                        self.fm.run(["geany", result])

        except KeyboardInterrupt:
            pass


class fzf_find_dir(Command):
    """
    Busca carpetas recursivamente desde el directorio actual y cambia a la carpeta seleccionada.
    Muestra un árbol de subcarpetas en la vista previa.
    """

    def execute(self):
        hidden_flag = "-H" if self.fm.settings["show_hidden"] else ""
        fzf_cmd = f"fd -t d {hidden_flag} --strip-cwd-prefix | fzf --preview 'tree -L 2 -C --dirsfirst {{}}'"

        try:
            fzf = self.fm.execute_command(
                fzf_cmd, universal_newlines=True, stdout=subprocess.PIPE
            )
            stdout, _ = fzf.communicate()

            if fzf.returncode == 0:
                result = os.path.abspath(stdout.rstrip("\n"))
                self.fm.cd(result)

        except KeyboardInterrupt:
            pass


# class fzflevelx(Command):
#     """
#     Busca archivos y directorios sin límite de profundidad y los selecciona en Ranger.
#     Muestra una vista previa de los archivos con sintaxis coloreada utilizando bat.
#     """
#
#     def execute(self):
#         search = self.fm.execute_command(
#             "fzf --preview 'bat --style=numbers --color=always {}'",
#             universal_newlines=True,
#             stdout=subprocess.PIPE,
#         )
#         stdout, _ = search.communicate()
#         if search.returncode == 0:
#             result = os.path.abspath(stdout.rstrip("\n"))
#             self.fm.select_file(result)

class fzflevelx(Command):
    """
    Busca archivos y directorios sin límite de profundidad y los selecciona en Ranger, incluyendo archivos ocultos.
    Muestra una vista previa de los archivos con sintaxis coloreada utilizando bat.
    """

    def execute(self):
        if self.fm.settings["show_hidden"]:
            hidden_flag = "-H"
        else:
            hidden_flag = ""

        # Modified command to include search.communicate() within the try block
        try:
            search = self.fm.execute_command(
                f"fd {hidden_flag} --type f --strip-cwd-prefix | fzf +m --preview 'bat --style=numbers --color=always {{}}'",
                universal_newlines=True,
                stdout=subprocess.PIPE,
            )
            stdout, _ = search.communicate()

            if search.returncode == 0:
                result = os.path.abspath(stdout.rstrip("\n"))
                self.fm.select_file(result)

        except KeyboardInterrupt:
            pass


#class fzdlevelx(Command):
#    """
#    Busca directorios sin límite de profundidad y cambia a ellos en Ranger.
#    Muestra un árbol de subdirectorios y una vista previa de los archivos con sintaxis coloreada utilizando bat.
#    """
#
#    def execute(self):
#        search = self.fm.execute_command(
#            "fd --type d --strip-cwd-prefix | fzf --preview 'tree -L 1 -C --dirsfirst {}'",
#            universal_newlines=True,
#            stdout=subprocess.PIPE,
#        )
#        stdout, _ = search.communicate()
#        if search.returncode == 0:
#            result = os.path.abspath(stdout.rstrip("\n"))
#            self.fm.cd(result)

class fzdlevelx(Command):
    """
    Busca directorios sin límite de profundidad y cambia a ellos en Ranger, incluyendo directorios ocultos.
    Muestra un árbol de subdirectorios y una vista previa de los archivos con sintaxis coloreada utilizando bat.
    """

    def execute(self):
        if self.fm.settings["show_hidden"]:
            hidden_flag = "-H"
        else:
            hidden_flag = ""

        search = self.fm.execute_command(
            f"fd {hidden_flag} --type d --strip-cwd-prefix | fzf --preview 'tree -L 1 -C --dirsfirst '",
            universal_newlines=True,
            stdout=subprocess.PIPE,
        )
        stdout, _ = search.communicate()

        if search.returncode == 0:
            result = os.path.abspath(stdout.rstrip("\n"))
            self.fm.cd(result)


class show_files_in_thunar(Command):
    """
    :show_files_in_thunar

    Abre la carpeta seleccionada en thunar
    """

    def execute(self):
        self.fm.run("thunar .", flags="f")
