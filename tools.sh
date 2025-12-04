#!/data/data/com.termux/files/usr/bin/python3
# -*- coding: utf-8 -*-

import os
import sys
import zipfile
import itertools
import time
from pathlib import Path

# ==================== ASCII ART ====================
RAAZ_LOGO = """
╔══════════════════════════════════════════╗
║ ██████╗  █████╗  █████╗ ███████╗███████╗║
║ ██╔══██╗██╔══██╗██╔══██╗╚══███╔╝██╔════╝║
║ ██████╔╝███████║███████║  ███╔╝ ███████╗║
║ ██╔══██╗██╔══██║██╔══██║ ███╔╝  ╚════██║║
║ ██║  ██║██║  ██║██║  ██║███████╗███████║║
║ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚══════╝║
║                                          ║
║      🔥 RAAZ TOOLBOX - TERMUX EDITION 🔥 ║
║         Command Line Interface          ║
╚══════════════════════════════════════════╝
"""

# ==================== COLORS FOR TERMUX ====================
class Colors:
    RED = '\033[91m'
    GREEN = '\033[92m'
    YELLOW = '\033[93m'
    BLUE = '\033[94m'
    MAGENTA = '\033[95m'
    CYAN = '\033[96m'
    WHITE = '\033[97m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'
    END = '\033[0m'

# ==================== ZIP PASSWORD CRACKER ====================
class TermuxZipCracker:
    def __init__(self):
        self.total_tried = 0
        self.start_time = time.time()
    
    def clear_screen(self):
        os.system('clear' if os.name == 'posix' else 'cls')
    
    def print_banner(self, text):
        print(f"\n{Colors.CYAN}{'='*60}{Colors.END}")
        print(f"{Colors.YELLOW}{Colors.BOLD}{text.center(60)}{Colors.END}")
        print(f"{Colors.CYAN}{'='*60}{Colors.END}\n")
    
    def print_menu(self):
        self.clear_screen()
        print(Colors.GREEN + RAAZ_LOGO + Colors.END)
        print(f"\n{Colors.BOLD}📱 Termux Toolbox - Main Menu{Colors.END}")
        print(f"{Colors.CYAN}{'-'*50}{Colors.END}")
        print(f"{Colors.WHITE}[1]{Colors.END} 🔓 ZIP Password Cracker")
        print(f"{Colors.WHITE}[2]{Colors.END} 🖼️  Background Remover")
        print(f"{Colors.WHITE}[3]{Colors.END} 🔄 File Converter")
        print(f"{Colors.WHITE}[4]{Colors.END} 🔧 Hex Editor")
        print(f"{Colors.WHITE}[5]{Colors.END} 📁 File Manager")
        print(f"{Colors.WHITE}[6]{Colors.END} 🛠️  System Tools")
        print(f"{Colors.WHITE}[0]{Colors.END} 🚪 Exit")
        print(f"{Colors.CYAN}{'-'*50}{Colors.END}")
    
    def get_choice(self):
        try:
            choice = input(f"\n{Colors.GREEN}👉 Select option (0-6): {Colors.END}")
            return int(choice)
        except:
            return -1
    
    # ========== ZIP CRACKING FUNCTIONS ==========
    def test_zip_password(self, zip_file, password):
        """Test if password works for zip file"""
        try:
            with zipfile.ZipFile(zip_file, 'r') as zf:
                # Try to read first file without extracting
                file_list = zf.namelist()
                if file_list:
                    # Try to open first file with password
                    zf.open(file_list[0], pwd=password.encode('utf-8')).read(10)
                    return True
        except:
            return False
        return False
    
    def dictionary_attack(self):
        """Dictionary attack on ZIP file"""
        self.print_banner("ZIP DICTIONARY ATTACK")
        
        # Get ZIP file
        zip_file = input(f"{Colors.WHITE}Enter ZIP file path: {Colors.END}").strip()
        if not os.path.exists(zip_file):
            print(f"{Colors.RED}❌ File not found!{Colors.END}")
            input("Press Enter to continue...")
            return
        
        # Get wordlist
        wordlist = input(f"{Colors.WHITE}Wordlist file [wordlist.txt]: {Colors.END}").strip()
        if not wordlist:
            wordlist = "wordlist.txt"
        
        # Create default wordlist if not exists
        if not os.path.exists(wordlist):
            print(f"{Colors.YELLOW}⚠️ Creating default wordlist...{Colors.END}")
            self.create_default_wordlist(wordlist)
        
        # Start attack
        print(f"\n{Colors.GREEN}🚀 Starting dictionary attack...{Colors.END}")
        print(f"{Colors.CYAN}Target:{Colors.END} {zip_file}")
        print(f"{Colors.CYAN}Wordlist:{Colors.END} {wordlist}")
        print(f"{Colors.CYAN}{'-'*50}{Colors.END}")
        
        try:
            with open(wordlist, 'r', errors='ignore', encoding='utf-8') as f:
                passwords = [line.strip() for line in f if line.strip()]
            
            total = len(passwords)
            found = False
            
            for idx, password in enumerate(passwords):
                self.total_tried += 1
                
                # Show progress
                if idx % 100 == 0:
                    progress = (idx / total) * 100
                    print(f"\r{Colors.YELLOW}Progress: {progress:.1f}% | Tried: {idx}/{total} | Current: {password[:20]}{Colors.END}", end='')
                
                # Test password
                if self.test_zip_password(zip_file, password):
                    print(f"\n\n{Colors.GREEN}{'='*60}{Colors.END}")
                    print(f"{Colors.GREEN}{Colors.BOLD}🎉 PASSWORD FOUND!{Colors.END}")
                    print(f"{Colors.GREEN}Password: {Colors.BOLD}{password}{Colors.END}")
                    print(f"{Colors.GREEN}Attempts: {self.total_tried}{Colors.END}")
                    print(f"{Colors.GREEN}{'='*60}{Colors.END}")
                    
                    # Extract files
                    self.extract_zip(zip_file, password)
                    found = True
                    break
            
            if not found:
                print(f"\n\n{Colors.RED}❌ Password not found in wordlist{Colors.END}")
                print(f"{Colors.YELLOW}Total attempts: {self.total_tried}{Colors.END}")
        
        except KeyboardInterrupt:
            print(f"\n\n{Colors.YELLOW}⚠️ Attack interrupted by user{Colors.END}")
        except Exception as e:
            print(f"\n{Colors.RED}❌ Error: {str(e)}{Colors.END}")
        
        input(f"\n{Colors.WHITE}Press Enter to continue...{Colors.END}")
    
    def brute_force_attack(self):
        """Brute force attack on ZIP file"""
        self.print_banner("ZIP BRUTE FORCE ATTACK")
        
        # Get ZIP file
        zip_file = input(f"{Colors.WHITE}Enter ZIP file path: {Colors.END}").strip()
        if not os.path.exists(zip_file):
            print(f"{Colors.RED}❌ File not found!{Colors.END}")
            input("Press Enter to continue...")
            return
        
        # Get parameters
        try:
            min_len = int(input(f"{Colors.WHITE}Minimum length [1]: {Colors.END}") or "1")
            max_len = int(input(f"{Colors.WHITE}Maximum length [4]: {Colors.END}") or "4")
            
            charset = input(f"{Colors.WHITE}Character set [a-z0-9]: {Colors.END}").strip()
            if not charset:
                charset = 'abcdefghijklmnopqrstuvwxyz0123456789'
            
            print(f"\n{Colors.GREEN}🚀 Starting brute force attack...{Colors.END}")
            print(f"{Colors.CYAN}Length range:{Colors.END} {min_len}-{max_len}")
            print(f"{Colors.CYAN}Charset size:{Colors.END} {len(charset)}")
            print(f"{Colors.CYAN}Total combinations:{Colors.END} {sum(len(charset)**i for i in range(min_len, max_len+1)):,}")
            print(f"{Colors.YELLOW}⚠️ This may take a long time!{Colors.END}")
            print(f"{Colors.CYAN}{'-'*50}{Colors.END}")
            
            input(f"{Colors.YELLOW}Press Enter to start or Ctrl+C to cancel...{Colors.END}")
            
            found = False
            start_time = time.time()
            
            for length in range(min_len, max_len + 1):
                if found:
                    break
                    
                for attempt in itertools.product(charset, repeat=length):
                    password = ''.join(attempt)
                    self.total_tried += 1
                    
                    # Show progress every 1000 attempts
                    if self.total_tried % 1000 == 0:
                        elapsed = time.time() - start_time
                        print(f"\r{Colors.YELLOW}Attempts: {self.total_tried:,} | Current: {password} | Time: {elapsed:.1f}s{Colors.END}", end='')
                    
                    # Test password
                    if self.test_zip_password(zip_file, password):
                        elapsed = time.time() - start_time
                        print(f"\n\n{Colors.GREEN}{'='*60}{Colors.END}")
                        print(f"{Colors.GREEN}{Colors.BOLD}🎉 PASSWORD FOUND!{Colors.END}")
                        print(f"{Colors.GREEN}Password: {Colors.BOLD}{password}{Colors.END}")
                        print(f"{Colors.GREEN}Attempts: {self.total_tried}{Colors.END}")
                        print(f"{Colors.GREEN}Time: {elapsed:.1f} seconds{Colors.END}")
                        print(f"{Colors.GREEN}{'='*60}{Colors.END}")
                        
                        # Extract files
                        self.extract_zip(zip_file, password)
                        found = True
                        break
            
            if not found:
                elapsed = time.time() - start_time
                print(f"\n\n{Colors.RED}❌ Password not found{Colors.END}")
                print(f"{Colors.YELLOW}Total attempts: {self.total_tried:,}{Colors.END}")
                print(f"{Colors.YELLOW}Total time: {elapsed:.1f} seconds{Colors.END}")
        
        except KeyboardInterrupt:
            print(f"\n\n{Colors.YELLOW}⚠️ Attack interrupted by user{Colors.END}")
        except ValueError:
            print(f"{Colors.RED}❌ Invalid input!{Colors.END}")
        except Exception as e:
            print(f"\n{Colors.RED}❌ Error: {str(e)}{Colors.END}")
        
        input(f"\n{Colors.WHITE}Press Enter to continue...{Colors.END}")
    
    def extract_zip(self, zip_file, password):
        """Extract ZIP file with password"""
        try:
            extract_dir = "extracted_files"
            os.makedirs(extract_dir, exist_ok=True)
            
            with zipfile.ZipFile(zip_file, 'r') as zf:
                zf.extractall(path=extract_dir, pwd=password.encode('utf-8'))
            
            file_count = len(os.listdir(extract_dir))
            print(f"{Colors.GREEN}✅ Successfully extracted {file_count} files to '{extract_dir}' folder{Colors.END}")
            return True
        except Exception as e:
            print(f"{Colors.RED}❌ Extraction failed: {str(e)}{Colors.END}")
            return False
    
    def create_default_wordlist(self, filename="wordlist.txt"):
        """Create default wordlist file"""
        common_passwords = [
            # Top 50 most common passwords
            "123456", "password", "12345678", "qwerty", "123456789",
            "12345", "1234", "111111", "1234567", "dragon",
            "123123", "baseball", "abc123", "football", "monkey",
            "letmein", "696969", "shadow", "master", "666666",
            "qwertyuiop", "123321", "mustang", "1234567890", "michael",
            "654321", "pussy", "superman", "1qaz2wsx", "7777777",
            "fuckyou", "121212", "000000", "qazwsx", "123qwe",
            "killer", "trustno1", "jordan", "jennifer", "zxcvbnm",
            "asdfgh", "hunter", "buster", "soccer", "harley",
            "batman", "andrew", "tigger", "sunshine", "iloveyou",
            
            # Common Indian passwords
            "password123", "india123", "delhi123", "mumbai123",
            "123456@", "password@123", "admin@123", "welcome123",
            "test123", "hello123", "god123", "loveyou",
            
            # Simple patterns
            "admin", "root", "user", "guest", "login",
            "welcome", "pass", "pass123", "1234abcd",
            
            # Year patterns
            "2020", "2021", "2022", "2023", "2024",
            "2019", "2018", "2017", "2000", "1990",
            
            # Name patterns
            "rahul", "rohit", "priya", "neha", "amit",
            "suresh", "kumar", "singh", "patel", "sharma"
        ]
        
        try:
            with open(filename, 'w', encoding='utf-8') as f:
                # Add basic passwords
                for pwd in common_passwords:
                    f.write(f"{pwd}\n")
                
                # Add number suffixes
                for pwd in common_passwords[:50]:
                    for num in ['', '123', '1234', '12345', '123456', '!', '@', '#', '$', '%']:
                        f.write(f"{pwd}{num}\n")
                
                # Add uppercase variants
                for pwd in common_passwords[:30]:
                    f.write(f"{pwd.upper()}\n")
            
            print(f"{Colors.GREEN}✅ Created wordlist with 500+ passwords: {filename}{Colors.END}")
            return True
        except Exception as e:
            print(f"{Colors.RED}❌ Failed to create wordlist: {str(e)}{Colors.END}")
            return False
    
    # ========== BACKGROUND REMOVER (Termux Compatible) ==========
    def background_remover_menu(self):
        """Background remover for Termux"""
        self.print_banner("BACKGROUND REMOVER")
        
        print(f"{Colors.YELLOW}Note:{Colors.END} For image processing in Termux, we recommend:")
        print("1. Install Termux-API for better image handling")
        print("2. Or use online tools for background removal")
        print("3. Or install 'imagemagick' package")
        
        print(f"\n{Colors.CYAN}Options:{Colors.END}")
        print(f"{Colors.WHITE}[1]{Colors.END} Install ImageMagick (recommended)")
        print(f"{Colors.WHITE}[2]{Colors.END} Use simple color-based remover")
        print(f"{Colors.WHITE}[3]{Colors.END} Go back")
        
        choice = input(f"\n{Colors.GREEN}Select option: {Colors.END}")
        
        if choice == '1':
            self.install_imagemagick()
        elif choice == '2':
            self.simple_bg_remover()
    
    def install_imagemagick(self):
        """Install ImageMagick in Termux"""
        print(f"\n{Colors.GREEN}Installing ImageMagick...{Colors.END}")
        os.system('pkg install imagemagick -y')
        print(f"{Colors.GREEN}✅ Installation complete!{Colors.END}")
        print(f"\n{Colors.CYAN}Usage examples:{Colors.END}")
        print("Remove white background: convert input.jpg -transparent white output.png")
        print("Make background transparent: convert input.jpg -fuzz 10% -transparent white output.png")
        input(f"\n{Colors.WHITE}Press Enter to continue...{Colors.END}")
    
    def simple_bg_remover(self):
        """Simple background remover using command line"""
        image_file = input(f"\n{Colors.WHITE}Enter image file path: {Colors.END}").strip()
        
        if not os.path.exists(image_file):
            print(f"{Colors.RED}❌ File not found!{Colors.END}")
            input("Press Enter to continue...")
            return
        
        # Check if ImageMagick is installed
        if os.system('which convert > /dev/null 2>&1') == 0:
            output_file = os.path.splitext(image_file)[0] + "_nobg.png"
            cmd = f'convert "{image_file}" -fuzz 10% -transparent white "{output_file}"'
            
            print(f"\n{Colors.YELLOW}Running command:{Colors.END} {cmd}")
            os.system(cmd)
            
            if os.path.exists(output_file):
                print(f"{Colors.GREEN}✅ Background removed! Saved as: {output_file}{Colors.END}")
            else:
                print(f"{Colors.RED}❌ Failed to remove background{Colors.END}")
        else:
            print(f"{Colors.RED}❌ ImageMagick not installed!{Colors.END}")
            print(f"{Colors.YELLOW}Run option 1 to install it first.{Colors.END}")
        
        input(f"\n{Colors.WHITE}Press Enter to continue...{Colors.END}")
    
    # ========== FILE CONVERTER ==========
    def file_converter_menu(self):
        """File converter for Termux"""
        self.print_banner("FILE CONVERTER")
        
        print(f"{Colors.CYAN}Available operations:{Colors.END}")
        print(f"{Colors.WHITE}[1]{Colors.END} 📄 Convert images to PDF")
        print(f"{Colors.WHITE}[2]{Colors.END} 🔄 Convert image formats")
        print(f"{Colors.WHITE}[3]{Colors.END} 🎵 Convert audio/video (ffmpeg)")
        print(f"{Colors.WHITE}[4]{Colors.END} ⬅️  Go back")
        
        choice = input(f"\n{Colors.GREEN}Select option: {Colors.END}")
        
        if choice == '1':
            self.images_to_pdf()
        elif choice == '2':
            self.convert_image_format()
        elif choice == '3':
            self.install_ffmpeg()
    
    def images_to_pdf(self):
        """Convert images to PDF using img2pdf"""
        print(f"\n{Colors.GREEN}Converting images to PDF{Colors.END}")
        
        # Check if img2pdf is available
        if os.system('which img2pdf > /dev/null 2>&1') != 0:
            print(f"{Colors.YELLOW}Installing img2pdf...{Colors.END}")
            os.system('pip install img2pdf')
        
        image_files = input(f"{Colors.WHITE}Enter image files (space separated): {Colors.END}").strip().split()
        
        if not image_files:
            print(f"{Colors.RED}❌ No files specified!{Colors.END}")
            input("Press Enter to continue...")
            return
        
        # Check if files exist
        valid_files = []
        for img in image_files:
            if os.path.exists(img):
                valid_files.append(img)
            else:
                print(f"{Colors.RED}⚠️ File not found: {img}{Colors.END}")
        
        if not valid_files:
            print(f"{Colors.RED}❌ No valid files found!{Colors.END}")
            input("Press Enter to continue...")
            return
        
        output_pdf = input(f"{Colors.WHITE}Output PDF name [output.pdf]: {Colors.END}").strip()
        if not output_pdf:
            output_pdf = "output.pdf"
        
        # Create command
        cmd = f'img2pdf {" ".join(valid_files)} -o "{output_pdf}"'
        
        print(f"\n{Colors.YELLOW}Running command:{Colors.END} {cmd}")
        os.system(cmd)
        
        if os.path.exists(output_pdf):
            size = os.path.getsize(output_pdf) / 1024  # KB
            print(f"{Colors.GREEN}✅ PDF created successfully!{Colors.END}")
            print(f"{Colors.CYAN}File: {output_pdf}{Colors.END}")
            print(f"{Colors.CYAN}Size: {size:.1f} KB{Colors.END}")
        else:
            print(f"{Colors.RED}❌ Failed to create PDF{Colors.END}")
        
        input(f"\n{Colors.WHITE}Press Enter to continue...{Colors.END}")
    
    def convert_image_format(self):
        """Convert between image formats using ImageMagick"""
        input_file = input(f"\n{Colors.WHITE}Enter input image file: {Colors.END}").strip()
        
        if not os.path.exists(input_file):
            print(f"{Colors.RED}❌ File not found!{Colors.END}")
            input("Press Enter to continue...")
            return
        
        print(f"\n{Colors.CYAN}Available formats:{Colors.END}")
        print("jpg, png, bmp, gif, tiff, webp, pdf")
        
        output_format = input(f"{Colors.WHITE}Output format [png]: {Colors.END}").strip().lower()
        if not output_format:
            output_format = "png"
        
        output_file = os.path.splitext(input_file)[0] + f".{output_format}"
        
        # Use ImageMagick for conversion
        if os.system('which convert > /dev/null 2>&1') == 0:
            cmd = f'convert "{input_file}" "{output_file}"'
            print(f"\n{Colors.YELLOW}Running command:{Colors.END} {cmd}")
            os.system(cmd)
            
            if os.path.exists(output_file):
                print(f"{Colors.GREEN}✅ Converted successfully!{Colors.END}")
                print(f"{Colors.CYAN}Output: {output_file}{Colors.END}")
            else:
                print(f"{Colors.RED}❌ Conversion failed{Colors.END}")
        else:
            print(f"{Colors.RED}❌ ImageMagick not installed!{Colors.END}")
            print(f"{Colors.YELLOW}Install it from the Background Remover menu.{Colors.END}")
        
        input(f"\n{Colors.WHITE}Press Enter to continue...{Colors.END}")
    
    def install_ffmpeg(self):
        """Install ffmpeg for audio/video conversion"""
        print(f"\n{Colors.GREEN}Installing FFmpeg...{Colors.END}")
        os.system('pkg install ffmpeg -y')
        print(f"{Colors.GREEN}✅ FFmpeg installed!{Colors.END}")
        print(f"\n{Colors.CYAN}Usage examples:{Colors.END}")
        print("Convert video to MP4: ffmpeg -i input.avi output.mp4")
        print("Extract audio: ffmpeg -i video.mp4 audio.mp3")
        print("Convert audio: ffmpeg -i audio.wav audio.mp3")
        input(f"\n{Colors.WHITE}Press Enter to continue...{Colors.END}")
    
    # ========== HEX EDITOR ==========
    def hex_editor_menu(self):
        """Hex editor for Termux"""
        self.print_banner("HEX EDITOR")
        
        print(f"{Colors.CYAN}Hex file operations:{Colors.END}")
        print(f"{Colors.WHITE}[1]{Colors.END} 📖 View file in hex")
        print(f"{Colors.WHITE}[2]{Colors.END} 🔍 Search hex pattern")
        print(f"{Colors.WHITE}[3]{Colors.END} ✏️  Edit hex bytes")
        print(f"{Colors.WHITE}[4]{Colors.END} ⬅️  Go back")
        
        choice = input(f"\n{Colors.GREEN}Select option: {Colors.END}")
        
        if choice == '1':
            self.view_hex_file()
        elif choice == '2':
            self.search_hex_pattern()
        elif choice == '3':
            self.edit_hex_bytes()
    
    def view_hex_file(self):
        """View file in hex format"""
        file_path = input(f"\n{Colors.WHITE}Enter file path: {Colors.END}").strip()
        
        if not os.path.exists(file_path):
            print(f"{Colors.RED}❌ File not found!{Colors.END}")
            input("Press Enter to continue...")
            return
        
        try:
            file_size = os.path.getsize(file_path)
            print(f"\n{Colors.CYAN}File: {file_path}{Colors.END}")
            print(f"{Colors.CYAN}Size: {file_size:,} bytes{Colors.END}")
            print(f"{Colors.CYAN}{'-'*70}{Colors.END}")
            
            with open(file_path, 'rb') as f:
                bytes_read = 0
                chunk_size = 1024
                
                while True:
                    chunk = f.read(16)  # Read 16 bytes at a time
                    if not chunk:
                        break
                    
                    # Hex representation
                    hex_str = ' '.join(f'{b:02x}' for b in chunk)
                    hex_str = hex_str.ljust(48)  # Pad for alignment
                    
                    # ASCII representation
                    ascii_str = ''.join(chr(b) if 32 <= b < 127 else '.' for b in chunk)
                    
                    print(f"{Colors.YELLOW}0x{bytes_read:08x}:{Colors.END} {Colors.GREEN}{hex_str}{Colors.END}  {Colors.CYAN}|{ascii_str}|{Colors.END}")
                    
                    bytes_read += len(chunk)
                    
                    # Pause every 20 lines
                    if bytes_read % (16 * 20) == 0:
                        print(f"\n{Colors.WHITE}--- Press Enter for more, 'q' to quit ---{Colors.END}")
                        if input().lower() == 'q':
                            break
            
            print(f"\n{Colors.CYAN}{'-'*70}{Colors.END}")
            print(f"{Colors.GREEN}✅ End of file reached{Colors.END}")
            
        except Exception as e:
            print(f"{Colors.RED}❌ Error reading file: {str(e)}{Colors.END}")
        
        input(f"\n{Colors.WHITE}Press Enter to continue...{Colors.END}")
    
    def search_hex_pattern(self):
        """Search for hex pattern in file"""
        file_path = input(f"\n{Colors.WHITE}Enter file path: {Colors.END}").strip()
        
        if not os.path.exists(file_path):
            print(f"{Colors.RED}❌ File not found!{Colors.END}")
            input("Press Enter to continue...")
            return
        
        pattern = input(f"{Colors.WHITE}Enter hex pattern to search (e.g., '504b0304' for ZIP): {Colors.END}").strip()
        
        if not pattern:
            print(f"{Colors.RED}❌ No pattern specified!{Colors.END}")
            input("Press Enter to continue...")
            return
        
        try:
            # Remove spaces from pattern
            pattern = pattern.replace(' ', '')
            pattern_bytes = bytes.fromhex(pattern)
            
            print(f"\n{Colors.CYAN}Searching for pattern: {pattern}{Colors.END}")
            print(f"{Colors.CYAN}Pattern length: {len(pattern_bytes)} bytes{Colors.END}")
            print(f"{Colors.CYAN}{'-'*50}{Colors.END}")
            
            with open(file_path, 'rb') as f:
                content = f.read()
            
            positions = []
            pos = content.find(pattern_bytes)
            
            while pos != -1:
                positions.append(pos)
                pos = content.find(pattern_bytes, pos + 1)
            
            if positions:
                print(f"{Colors.GREEN}✅ Found {len(positions)} occurrence(s){Colors.END}")
                for idx, pos in enumerate(positions[:10]):  # Show first 10
                    print(f"{Colors.YELLOW}[{idx+1}]{Colors.END} Position: 0x{pos:08x} (decimal: {pos})")
                
                if len(positions) > 10:
                    print(f"{Colors.YELLOW}... and {len(positions)-10} more{Colors.END}")
            else:
                print(f"{Colors.RED}❌ Pattern not found{Colors.END}")
        
        except ValueError:
            print(f"{Colors.RED}❌ Invalid hex pattern!{Colors.END}")
        except Exception as e:
            print(f"{Colors.RED}❌ Error: {str(e)}{Colors.END}")
        
        input(f"\n{Colors.WHITE}Press Enter to continue...{Colors.END}")
    
    def edit_hex_bytes(self):
        """Edit hex bytes in file"""
        file_path = input(f"\n{Colors.WHITE}Enter file path: {Colors.END}").strip()
        
        if not os.path.exists(file_path):
            print(f"{Colors.RED}❌ File not found!{Colors.END}")
            input("Press Enter to continue...")
            return
        
        try:
            # Make backup
            backup_path = file_path + '.bak'
            os.system(f'cp "{file_path}" "{backup_path}"')
            print(f"{Colors.YELLOW}✅ Backup created: {backup_path}{Colors.END}")
            
            offset = input(f"{Colors.WHITE}Enter offset (decimal or hex with 0x): {Colors.END}").strip()
            
            # Parse offset
            if offset.startswith('0x'):
                offset = int(offset[2:], 16)
            else:
                offset = int(offset)
            
            new_hex = input(f"{Colors.WHITE}Enter new hex bytes (e.g., 'FF00AA'): {Colors.END}").strip().replace(' ', '')
            
            if len(new_hex) % 2 != 0:
                print(f"{Colors.RED}❌ Hex string must have even number of characters!{Colors.END}")
                input("Press Enter to continue...")
                return
            
            new_bytes = bytes.fromhex(new_hex)
            
            # Edit file
            with open(file_path, 'r+b') as f:
                f.seek(offset)
                f.write(new_bytes)
            
            print(f"{Colors.GREEN}✅ File edited successfully!{Colors.END}")
            print(f"{Colors.CYAN}Offset: 0x{offset:08x}{Colors.END}")
            print(f"{Colors.CYAN}Bytes written: {len(new_bytes)}{Colors.END}")
            
        except ValueError:
            print(f"{Colors.RED}❌ Invalid offset or hex data!{Colors.END}")
        except Exception as e:
            print(f"{Colors.RED}❌ Error editing file: {str(e)}{Colors.END}")
        
        input(f"\n{Colors.WHITE}Press Enter to continue...{Colors.END}")
    
    # ========== FILE MANAGER ==========
    def file_manager_menu(self):
        """Simple file manager"""
        self.print_banner("FILE MANAGER")
        
        print(f"{Colors.CYAN}Current directory: {os.getcwd()}{Colors.END}")
        print(f"{Colors.CYAN}{'-'*50}{Colors.END}")
        
        # List files
        files = os.listdir('.')
        for idx, file in enumerate(files[:20]):  # Show first 20
            if os.path.isdir(file):
                print(f"{Colors.BLUE}[DIR] {file}{Colors.END}")
            else:
                size = os.path.getsize(file)
                print(f"{Colors.WHITE}[FILE] {file} ({size:,} bytes){Colors.END}")
        
        if len(files) > 20:
            print(f"{Colors.YELLOW}... and {len(files)-20} more files{Colors.END}")
        
        print(f"\n{Colors.CYAN}Operations:{Colors.END}")
        print(f"{Colors.WHITE}[1]{Colors.END} Change directory")
        print(f"{Colors.WHITE}[2]{Colors.END} Create directory")
        print(f"{Colors.WHITE}[3]{Colors.END} Delete file/directory")
        print(f"{Colors.WHITE}[4]{Colors.END} View file info")
        print(f"{Colors.WHITE}[5]{Colors.END} Go back")
        
        choice = input(f"\n{Colors.GREEN}Select option: {Colors.END}")
        
        if choice == '1':
            new_dir = input(f"{Colors.WHITE}Enter directory path: {Colors.END}").strip()
            try:
                os.chdir(new_dir)
                print(f"{Colors.GREEN}✅ Changed to: {os.getcwd()}{Colors.END}")
            except:
                print(f"{Colors.RED}❌ Invalid directory!{Colors.END}")
            input("Press Enter to continue...")
        
        elif choice == '2':
            dir_name = input(f"{Colors.WHITE}Enter directory name: {Colors.END}").strip()
            try:
                os.makedirs(dir_name, exist_ok=True)
                print(f"{Colors.GREEN}✅ Directory created: {dir_name}{Colors.END}")
            except:
                print(f"{Colors.RED}❌ Failed to create directory{Colors.END}")
            input("Press Enter to continue...")
        
        elif choice == '3':
            target = input(f"{Colors.WHITE}Enter file/directory to delete: {Colors.END}").strip()
            if os.path.exists(target):
                confirm = input(f"{Colors.RED}Are you sure? (y/N): {Colors.END}").lower()
                if confirm == 'y':
                    if os.path.isdir(target):
                        os.system(f'rm -rf "{target}"')
                        print(f"{Colors.GREEN}✅ Directory deleted: {target}{Colors.END}")
                    else:
                        os.remove(target)
                        print(f"{Colors.GREEN}✅ File deleted: {target}{Colors.END}")
            else:
                print(f"{Colors.RED}❌ File/directory not found!{Colors.END}")
            input("Press Enter to continue...")
        
        elif choice == '4':
            target = input(f"{Colors.WHITE}Enter file path: {Colors.END}").strip()
            if os.path.exists(target):
                size = os.path.getsize(target)
                modified = time.ctime(os.path.getmtime(target))
                
                print(f"\n{Colors.CYAN}File Information:{Colors.END}")
                print(f"{Colors.WHITE}Name:{Colors.END} {target}")
                print(f"{Colors.WHITE}Size:{Colors.END} {size:,} bytes ({size/1024:.1f} KB)")
                print(f"{Colors.WHITE}Modified:{Colors.END} {modified}")
                print(f"{Colors.WHITE}Type:{Colors.END} {'Directory' if os.path.isdir(target) else 'File'}")
                
                # Check if it's a known file type
                if target.lower().endswith('.zip'):
                    print(f"{Colors.WHITE}File type:{Colors.END} ZIP Archive")
                    try:
                        with zipfile.ZipFile(target, 'r') as zf:
                            print(f"{Colors.WHITE}Files inside:{Colors.END} {len(zf.namelist())}")
                    except:
                        pass
            else:
                print(f"{Colors.RED}❌ File not found!{Colors.END}")
            input("Press Enter to continue...")
    
    # ========== SYSTEM TOOLS ==========
    def system_tools_menu(self):
        """System tools for Termux"""
        self.print_banner("SYSTEM TOOLS")
        
        print(f"{Colors.CYAN}System information:{Colors.END}")
        os.system('uname -a')
        print()
        
        print(f"{Colors.CYAN}Available tools:{Colors.END}")
        print(f"{Colors.WHITE}[1]{Colors.END} 📊 Disk usage")
        print(f"{Colors.WHITE}[2]{Colors.END} 📈 Process monitor")
        print(f"{Colors.WHITE}[3]{Colors.END} 🌐 Network tools")
        print(f"{Colors.WHITE}[4]{Colors.END} 🛠️  Package manager")
        print(f"{Colors.WHITE}[5]{Colors.END} ⬅️  Go back")
        
        choice = input(f"\n{Colors.GREEN}Select option: {Colors.END}")
        
        if choice == '1':
            os.system('df -h')
            input(f"\n{Colors.WHITE}Press Enter to continue...{Colors.END}")
        
        elif choice == '2':
            os.system('ps aux')
            input(f"\n{Colors.WHITE}Press Enter to continue...{Colors.END}")
        
        elif choice == '3':
            self.network_tools()
        
        elif choice == '4':
            self.package_manager()
    
    def network_tools(self):
        """Network diagnostic tools"""
        print(f"\n{Colors.CYAN}Network Tools:{Colors.END}")
        print(f"{Colors.WHITE}[1]{Colors.END} Ping test")
        print(f"{Colors.WHITE}[2]{Colors.END} Download file")
        print(f"{Colors.WHITE}[3]{Colors.END} Check connectivity")
        print(f"{Colors.WHITE}[4]{Colors.END} Go back")
        
        choice = input(f"\n{Colors.GREEN}Select option: {Colors.END}")
        
        if choice == '1':
            host = input(f"{Colors.WHITE}Enter host to ping: {Colors.END}").strip()
            os.system(f'ping -c 4 {host}')
            input(f"\n{Colors.WHITE}Press Enter to continue...{Colors.END}")
        
        elif choice == '2':
            url = input(f"{Colors.WHITE}Enter URL to download: {Colors.END}").strip()
            filename = input(f"{Colors.WHITE}Save as [press Enter for default]: {Colors.END}").strip()
            if not filename:
                filename = url.split('/')[-1]
            
            print(f"\n{Colors.YELLOW}Downloading {url}...{Colors.END}")
            os.system(f'wget -O "{filename}" "{url}"')
            input(f"\n{Colors.WHITE}Press Enter to continue...{Colors.END}")
    
    def package_manager(self):
        """Termux package manager interface"""
        print(f"\n{Colors.CYAN}Package Manager:{Colors.END}")
        print(f"{Colors.WHITE}[1]{Colors.END} Update packages")
        print(f"{Colors.WHITE}[2]{Colors.END} Install package")
        print(f"{Colors.WHITE}[3]{Colors.END} Remove package")
        print(f"{Colors.WHITE}[4]{Colors.END} List installed")
        print(f"{Colors.WHITE}[5]{Colors.END} Go back")
        
        choice = input(f"\n{Colors.GREEN}Select option: {Colors.END}")
        
        if choice == '1':
            os.system('pkg update && pkg upgrade -y')
            input(f"\n{Colors.WHITE}Press Enter to continue...{Colors.END}")
        
        elif choice == '2':
            pkg = input(f"{Colors.WHITE}Enter package name: {Colors.END}").strip()
            os.system(f'pkg install {pkg} -y')
            input(f"\n{Colors.WHITE}Press Enter to continue...{Colors.END}")
    
    # ========== MAIN MENU HANDLER ==========
    def run(self):
        """Main program loop"""
        while True:
            self.print_menu()
            choice = self.get_choice()
            
            if choice == 0:
                self.clear_screen()
                print(f"\n{Colors.GREEN}👋 Thanks for using Raaz Toolbox!{Colors.END}")
                print(f"{Colors.CYAN}Made with ❤️ for Termux users{Colors.END}\n")
                break
            
            elif choice == 1:
                self.zip_cracker_menu()
            
            elif choice == 2:
                self.background_remover_menu()
            
            elif choice == 3:
                self.file_converter_menu()
            
            elif choice == 4:
                self.hex_editor_menu()
            
            elif choice == 5:
                self.file_manager_menu()
            
            elif choice == 6:
                self.system_tools_menu()
            
            else:
                print(f"{Colors.RED}❌ Invalid choice! Please try again.{Colors.END}")
                time.sleep(1)
    
    def zip_cracker_menu(self):
        """ZIP cracker menu"""
        self.print_banner("ZIP PASSWORD CRACKER")
        
        print(f"{Colors.CYAN}Attack methods:{Colors.END}")
        print(f"{Colors.WHITE}[1]{Colors.END} 🗂️  Dictionary attack")
        print(f"{Colors.WHITE}[2]{Colors.END} 💥 Brute force attack")
        print(f"{Colors.WHITE}[3]{Colors.END} 🔧 Create wordlist")
        print(f"{Colors.WHITE}[4]{Colors.END} 📦 Extract ZIP (with password)")
        print(f"{Colors.WHITE}[5]{Colors.END} ⬅️  Go back")
        
        choice = input(f"\n{Colors.GREEN}Select option: {Colors.END}")
        
        if choice == '1':
            self.dictionary_attack()
        elif choice == '2':
            self.brute_force_attack()
        elif choice == '3':
            filename = input(f"{Colors.WHITE}Wordlist filename [wordlist.txt]: {Colors.END}").strip()
            if not filename:
                filename = "wordlist.txt"
            self.create_default_wordlist(filename)
            input(f"\n{Colors.WHITE}Press Enter to continue...{Colors.END}")
        elif choice == '4':
            zip_file = input(f"{Colors.WHITE}Enter ZIP file: {Colors.END}").strip()
            password = input(f"{Colors.WHITE}Enter password: {Colors.END}").strip()
            if zip_file and password:
                self.extract_zip(zip_file, password)
            input(f"\n{Colors.WHITE}Press Enter to continue...{Colors.END}")

# ==================== MAIN EXECUTION ====================
if __name__ == "__main__":
    try:
        # Clear screen
        os.system('clear')
        
        # Check if running in Termux
        if 'com.termux' not in os.getcwd():
            print(f"{Colors.YELLOW}⚠️  Warning: This tool is optimized for Termux{Colors.END}")
            print(f"{Colors.YELLOW}It should still work on other systems.{Colors.END}")
            time.sleep(2)
        
        # Create output directory
        os.makedirs("extracted_files", exist_ok=True)
        
        # Run the toolbox
        toolbox = TermuxZipCracker()
        toolbox.run()
        
    except KeyboardInterrupt:
        print(f"\n\n{Colors.YELLOW}⚠️  Program interrupted by user{Colors.END}")
        print(f"{Colors.GREEN}👋 Goodbye!{Colors.END}")
    except Exception as e:
        print(f"\n{Colors.RED}❌ Unexpected error: {str(e)}{Colors.END}")
        print(f"{Colors.YELLOW}Please report this issue.{Colors.END}")