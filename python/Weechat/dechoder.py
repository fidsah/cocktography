#-*- coding: utf-8 -*-
from __future__ import unicode_literals
import regex as re
try:
    import weechat
except:
    raise Exception("This module must be used with Weechat!")
if __name__ == '__main__' and __package__ is None:
    from os import sys, path
    sys.path.append(path.dirname(path.dirname(path.abspath(__file__))))
from CPI import cocktography


RE_host = re.compile(r"(?<=\:).*(?= PRIVMSG)")


api = cocktography.Cocktograph()

__COCKS = {}


def colorize(text):
    try:
        text = text.encode('utf-8')
    except:
        pass
    result = weechat.hook_modifier_exec("irc_color_decode", "1", text)
    return(unicode(result, 'utf-8', errors='ignore'))


def format_for_weechat(text, colorize=True):
    return(colorize(text).encode('utf-8'))


def autococktography(data, modifier, modifier_data, string):
    global api, __COCKS
    raw_message = api.to_unicode(string)
    message = api.get_cockstring(string)
    if not message or "irc_raw" in modifier_data:
        return(string)
    user = RE_host.search(string)
    user = user.group(0) if user else "null"
    if message.startswith(api.START) or message.startswith(api.MARK):
        history = __COCKS.get(user, [])
        if message.endswith(api.STOP):
            if message.startswith(api.START): # we have a single line enchoded message
                dechoded = api.dechode(message)
                formatted = raw_message.replace(message, dechoded)
                __COCKS[user] = []
                return(format_for_weechat(formatted))
            else:
                enchoded = " ".join(history + [message])
                __COCKS[user] = []
                dechoded = api.dechode(enchoded)
                formatted = raw_message.replace(message, dechoded)
                return(format_for_weechat(formatted))
        else:
            __COCKS[user] = history + [message]
            return ""


def enchoder_cmd(data, buffer, args):
    enchoded = api.enchode(args[:150])
    weechat.command(buffer, enchoded)
    return weechat.WEECHAT_RC_OK


def dechoder_cmd(data, buffer, args):
    dechoded = api.dechode(args)
    weechat.prnt(buffer, dechoded)
    return weechat.WEECHAT_RC_OK


if __name__ == "__main__":
    weechat.register("dechoder_ring", "Dechoder", "1.0", "GPL3", "Test script", "", "")
    weechat.hook_modifier("weechat_print", "autococktography", "")

    hook = weechat.hook_command("dechode",
        "You know what this does.",
        "",
        "Your message",
        "",
        "dechoder_cmd", "")

    hook = weechat.hook_command("enchode",
        "You know what this does.",
        "",
        "Your message",
        "",
        "enchoder_cmd", "")
