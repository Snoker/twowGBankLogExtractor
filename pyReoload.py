import pyautogui
import subprocess
import time

interval = 10  # seconds
wow_window_name = "World of Warcraft"  # adjust if needed

def _sendShiftChar(char):
    pyautogui.keyDown('shift')
    pyautogui.press(char)
    pyautogui.keyUp('shift')


def _interactWithNPC():

    screenWidth, screenHeight = pyautogui.size()
    x = int(screenWidth * 0.25)
    y = int(screenHeight * 0.5)
    
    pyautogui.moveTo(x, y, duration=0.5)
    pyautogui.click(button='right')
    print(f"Clicked at ({x}, {y}) to interact with NPC.")

def activate_wow_window():
    try:
        # Use xdotool to get window ID
        result = subprocess.run(
            ["xdotool", "search", "--name", wow_window_name],
            capture_output=True, text=True
        )
        window_ids = result.stdout.strip().split("\n")
        if not window_ids or window_ids[0] == "":
            return False
        # Activate the first matching window
        subprocess.run(["xdotool", "windowactivate", window_ids[0]])
        return True
    except Exception as e:
        print(f"Error activating window: {e}")
        return False

while True:
    if activate_wow_window():
        time.sleep(1)  # wait for focus
        _interactWithNPC()
        time.sleep(6)  # wait for NPC dialog to open -> THIS IS GBANK, MEGA SLOW
        pyautogui.press("enter")
        _sendShiftChar('7')
        pyautogui.typewrite("gb")
        pyautogui.press("enter")
        time.sleep(1.5) #wait to make sure we don't do this too fast after collecting data
        pyautogui.press("enter")
        _sendShiftChar('7')
        pyautogui.typewrite("run ReloadUI")
        _sendShiftChar('8')
        _sendShiftChar('9')
        pyautogui.press("enter")
        time.sleep(5) #ensure UI is reloaded before we procceed
        
        

        print("Sent /run ReloadUI()")
    else:
        print("WoW window not found, retrying...")

    time.sleep(interval)
