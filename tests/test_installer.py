"""Exercise the real installer with an isolated KDE package directory."""
import os
from pathlib import Path
import subprocess
import tempfile
import unittest


class InstallerTest(unittest.TestCase):
    def test_fresh_install_and_update(self):
        project = Path(__file__).resolve().parents[1]
        with tempfile.TemporaryDirectory(prefix=".installer-test-", dir=project) as data:
            env = dict(os.environ, XDG_DATA_HOME=data)
            installed = Path(data) / "ksysguard/sensorfaces/org.kde.ksysguard.simpletext"
            for action in ("fresh install", "update"):
                with self.subTest(action=action):
                    result = subprocess.run(
                        ["sh", str(project / "install.sh")],
                        cwd=project if action == "fresh install" else data,
                        env=env, capture_output=True, text=True,
                    )
                    self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
                    self.assertTrue((installed / "metadata.json").is_file())


if __name__ == "__main__":
    unittest.main()
