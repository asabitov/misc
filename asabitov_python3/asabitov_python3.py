def add_help(help_msg: str):
    """Add help option to a main function"""

    def actual_decor(main_func):
        import sys

        def wrapper(*args, **kwargs):
            try:
                if ('-h' in sys.argv) or ('--help' in sys.argv):
                    print(help_msg)
                    sys.exit(0)
                else:
                    main_func(*args, **kwargs)
            except Exception as error:
                print('Sorry, something went wrong:')
                print(error)

        return wrapper

    return actual_decor


def send_email(from_addr: str, to_addrs: list, subj: str, body: str) -> None:
    """Send email using the local mail server"""

    import smtplib

    message = 'From: {}\nTo: {}\nSubject: {}\n{}'.format(from_addr,
                                                         '; '.join(to_addrs),
                                                         subj,
                                                         body)

    smtpObj = smtplib.SMTP('localhost')
    smtpObj.sendmail(from_addr, to_addrs, message)


def run_ssh_command(ssh_username: str,
                       ssh_password: str,
                       host: str,
                       ssh_command: str) -> str:
    """Run a shell command remotely via SSH"""

    import paramiko

    ssh_client = paramiko.SSHClient()
    ssh_client.set_missing_host_key_policy(paramiko.AutoAddPolicy())

    ssh_client.connect(host, username=ssh_username, password=ssh_password)
    ssh_stdin, ssh_stdout, ssh_stderr = ssh_client.exec_command(ssh_command)

    output = ssh_stdout.read() + ssh_stderr.read()

    ssh_client.close()

    return output
