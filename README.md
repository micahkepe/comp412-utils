# comp412-utils

Utility scripts and reference materials for COMP 412 @ Rice University.

> [!NOTE]
> This repository does not provide a testing framework for labs. For that, I
> recommend the [`zill412`](https://github.com/zawie/zill412) repository, which
> you can add a Git submodule to your lab repositories:
>
> ```bash
> git submodule add https://github.com/zawie/zill412 zill412
> ```
>
> If you are using the `make_submission.sh` script below, the `zill412`
> submodule is already in exclude patterns, so you do not need to add it.

- [ILOC Blocks](#iloc-blocks)
- [Scripts](#scripts)
  - [fetch_new_lectures](#fetch_new_lectures)
    - [Setting Up as cron Job](#setting-up-as-cron-job)
  - [make_submission](#make_submission)
  - [Copying to CLEAR](#copying-to-clear)
- [video_links](#video_links)
  - [Save All Links to Markdown File](#save-all-links-to-markdown-file)
  - [Example: Fetch all links for lab 1:](#example-fetch-all-links-for-lab-1)
  - [Example: Get plain text links for all videos (mp4 files):](#example-get-plain-text-links-for-all-videos-mp4-files)
  - [Local Simulator Testing](#local-simulator-testing)
- [Contributing](#contributing)

---

## ILOC Blocks

In the [`ILOC`](./ILOC/) directory, you will find the full list of ILOC blocks
that can be used for testing and benchmarking.

---

## Scripts

### `fetch_new_lectures`

This script can be run on your local machine to download the lecture and
supplementary files from the CLEAR server. You can choose to include the videos
as well.

```
Usage: ./fetch_new_lectures.sh [-n|--netid <netid>] [-i|--include-videos] [-h|--help]

Options:
  -n, --netid <netid>      Your netid on the CLEAR server
  -i, --include-videos     Include videos from the lecture directory
  -h, --help               Print this help message
```

#### Setting Up as `cron` Job

Handily, you can set up this script to run as a `cron` job. To do so, add the
following line to your `crontab`:

1. Open your `crontab` with `crontab -e` (this will open in whatever your
   default editor `$EDITOR` is set to).

2. Add the following line to the end of the file:

   ```bash
   30 10 * * Mon,Tue,Fri ~/path/to/comp412-utils/fetch_new_lectures.sh
   ```

   This will run the script every Monday, Tuesday, and Friday at 10:30am (local
   system time).

3. Save and exit the file.

4. Verify that the job is running by running `crontab -l`. You should see the
   newly added job listed.

### `make_submission`

This script is intended to be **run on CLEAR**. It creates a TAR archive of the
source code for the given lab directory, and then saves it to the `submissions/`
folder, as well as creating a timestamped backup of the TAR in
`submissions/backups`.

Additionally, it checks that the `Makefile` targets `clean` and `build` work
before creating the submission. If either target fails, the script will exit
with an error.

After the submission is created, it will display a message of the necessary
command to submit the lab.

> [!NOTE]
> This script was original written for Rust labs as that is the language
> I am using, but you can easily modify the script's `EXCLUDE_PATTERNS` variable
> to exclude files or directories that you do not want to include in the
> submission based on your language of choice.

```
Usage: ./make_submission.sh <source directory> [-l | --lab] <lab-num>
  <source directory>	Directory containing the source code
  -l, --lab 		Lab number
  -h, --help		Print help
```

### Copying to CLEAR

You can either clone this repository directly on CLEAR, or manually copy the
`make_submission.sh` script with `scp`:

```bash
cd comp412-utils
scp make_submission.sh netid@ssh.clear.rice.edu:/path/to/store/make_submission.sh
```

## `video_links`

Prints to stdout Markdown-formatted or plain text links for all the
videos/resources that are in the remote `/clear/www/htdocs/comp412/Support/`
directory. Useful for copy-pasting to Piazza Markdown editor.

Usage:

```
Usage: ./video_links.sh [-n | --netid <netid>] [-p | --plain]
Options:
  -n, --netid <netid>      Your netid on the CLEAR server
  -p, --plain              Print plain text links instead of Markdown
  -h, --help               Print this help message
```

### Save All Links to Markdown File

```bash
echo -e "# Video Links\n" > links.md; ./video_links.sh | awk '{ print "- "$0 }' >> links.md
```

### Example: Fetch all links for lab 1:

```bash
./video_links.sh | grep "Lab1"
```

### Example: Get plain text links for all videos (mp4 files):

```bash
./video_links.sh -p | grep "\.mp4"
```

---

### Local Simulator Testing

You can use `scp` to obtain a local copy of the ILOC simulator from CLEAR:

For MacOS:

```bash
scp netid@ssh.clear.rice.edu:/clear/www/htdocs/comp412/simForMacOS macos-sim
```

For Linux:

```bash
scp netid@ssh.clear.rice.edu:/clear/courses/comp412/students/lab2/sim sim
```

## Contributing

Contributions are welcome! Please open an issue or submit a pull request if you
find a bug, have another script, or have a suggestion for a new script.
