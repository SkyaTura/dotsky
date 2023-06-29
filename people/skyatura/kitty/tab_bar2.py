import datetime
from kitty.fast_data_types import (Screen)
from kitty.tab_bar import (
    Formatter,
    DrawData,
    ExtraData,
    TabBarData,
    draw_tab_with_powerline,
    draw_attributed_string,
    as_rgb,
)

def draw_tab(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    before: int,
    max_tab_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData
) -> int:
    draw_tab_with_powerline(
        draw_data,
        screen,
        tab,
        before,
        max_tab_length,
        index,
        is_last,
        extra_data
    )
    if is_last:
        draw_right_status(draw_data, screen)
    return screen.cursor.x


def draw_right_status(draw_data: DrawData, screen: Screen) -> None:
    # The tabs may have left some formats enabled. Disable them now.
    draw_attributed_string(Formatter.reset, screen)
    cells = create_cells()
    # Drop cells that wont fit
    while True:
        if not cells:
            return
        padding = screen.columns - screen.cursor.x - sum(len(c) + 3 for c in cells)
        if padding >= 0:
            break
        cells = cells[1:]

    if padding:
        screen.draw(" " * padding)

    tab_bg = as_rgb(int(draw_data.inactive_bg))
    tab_fg = as_rgb(int(draw_data.inactive_fg))
    default_bg = as_rgb(int(draw_data.default_bg))
    for cell in cells:
        # Draw the separator
        if cell == cells[0]:
            screen.cursor.fg = tab_bg
            screen.draw("")
        else:
            screen.cursor.fg = default_bg
            screen.cursor.bg = tab_bg
            screen.draw("")
        screen.cursor.fg = tab_fg
        screen.cursor.bg = tab_bg
        screen.draw(f" {cell} ")


def create_cells() -> list[str]:
    now = datetime.datetime.now()
    return [
        # currently_playing(),
        # get_headphone_battery_status(),
        # now.strftime("%d %b"),
        now.strftime("%d %b %H:%M"),
    ]



def _redraw_tab_bar(timer_id):
    for tm in get_boss().all_tab_managers:
        tm.mark_tab_bar_dirty()
