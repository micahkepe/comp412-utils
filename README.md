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
> and ignore in your lab's `.gitignore` by adding `zill412` to the list.

## ILOC Blocks

In the [`ILOC`](./ILOC/) directory, you will find the full list of ILOC blocks
that can be used for testing and benchmarking.

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
