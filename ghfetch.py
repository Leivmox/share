
#!/usr/bin/env python3
import requests
import sys
from datetime import datetime


DEFAULT_USER = "Kush-ShuL"
DOT = "■ "
EMPTY_DOT = "  "
TIMEOUT = 5
INDENT = "    "


COLORS = [
    "\033[38;5;235m",
    "\033[38;5;22m",
    "\033[38;5;28m",
    "\033[38;5;40m",
    "\033[38;5;46m",
]
RESET = "\033[0m"
BOLD = "\033[1m"
GRAY = "\033[38;5;242m"
RED = "\033[38;5;196m"
CYAN = "\033[38;5;45m"


def fetch_and_show(username):
    try:
        response = requests.get(
            f"https://github-contributions-api.jogruber.de/v4/{username}?y=last",
            timeout=TIMEOUT,
        )

        if response.status_code == 404:
            print(f"\n{INDENT}{RED}!{RESET} {GRAY}未找到用户 '{username}'.{RESET}\n")
            return
        elif response.status_code != 200:
            print(f"\n{INDENT}{RED}!{RESET} {GRAY}API 请求失败.{RESET}\n")
            return

        data = response.json()
        conts = data["contributions"][-154:]

        if conts:
            first_date_str = conts[0]["date"]
            first_date = datetime.strptime(first_date_str, "%Y-%m-%d")

            start_weekday_index = (first_date.weekday() + 1) % 7

            padding = [{"level": -1, "date": None}] * start_weekday_index
            conts = padding + conts

        grid = [[] for _ in range(7)]

        cols = []

        current_week = []
        for i, day in enumerate(conts):
            grid[i % 7].append(day["level"])
            current_week.append(day)

            if (i + 1) % 7 == 0 or i == len(conts) - 1:
                cols.append(current_week)
                current_week = []

        total = sum(d["count"] for d in data["contributions"])

        print(
            f"\n{INDENT}{CYAN}{RESET} {BOLD}{username}{RESET} on {BOLD}GitHub{RESET}"
        )

        month_line = " " * 5
        last_month = -1
        month_names_cn = [
            "",
            "1月",
            "2月",
            "3月",
            "4月",
            "5月",
            "6月",
            "7月",
            "8月",
            "9月",
            "10月",
            "11月",
            "12月",
        ]

        for col_idx, week_data in enumerate(cols):

            valid_day = next((d for d in week_data if d.get("date")), None)

            label_added = False
            if valid_day:
                dt = datetime.strptime(valid_day["date"], "%Y-%m-%d")
                curr_month = dt.month

                if curr_month != last_month:
                    if col_idx == 0 or (col_idx - last_month_col_idx > 2):
                        month_str = month_names_cn[curr_month]
                        month_line += f"{GRAY}{month_str}{RESET}"

                        padding_len = 2 - (len(month_str.encode("gbk")) // 2)
                        if padding_len < 0:
                            padding_len = 0

                        last_month = curr_month
                        last_month_col_idx = col_idx
                        label_added = True

            if not label_added:
                month_line += "  "
            else:

                pass

        print_month_line = f"{INDENT}     "
        last_m = -1
        col_counter = 0

        for week_data in cols:
            valid_day = next((d for d in week_data if d.get("date")), None)
            symbol = "  "

            if valid_day:
                m = datetime.strptime(valid_day["date"], "%Y-%m-%d").month

                if m != last_m and col_counter > 2:

                    if len(cols) - cols.index(week_data) > 2:
                        symbol = f"{m}月"

                        if m >= 10:

                            pass
                        last_m = m
                        col_counter = 0

            if "月" in symbol:
                print_month_line += f"{GRAY}{symbol}{RESET}"

            else:
                print_month_line += "  "

            col_counter += 1

        print(print_month_line)

        days_label = ["     ", " 周一", "     ", " 周三", "     ", " 周五", "     "]

        for i, row in enumerate(grid):

            print(f"{INDENT}{GRAY}{days_label[i]}{RESET} ", end="")

            for level in row:
                if level == -1:
                    print(f"{EMPTY_DOT}", end="")
                else:
                    print(f"{COLORS[level]}{DOT}{RESET}", end="")
            print()

        print(f"{INDENT}{GRAY}过去一年共提交 {total} 次{RESET}\n")

    except requests.exceptions.RequestException:
        print(f"\n{INDENT}{RED}!{RESET} {GRAY}网络错误或超时.{RESET}\n")


if __name__ == "__main__":
    target_user = sys.argv[1] if len(sys.argv) > 1 else DEFAULT_USER
    fetch_and_show(target_user)
