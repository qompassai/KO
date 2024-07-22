# Kyber's Odyssey: Charting a course for secure research & innovation in a post-Crowdstrike world
## Authors

Matt A. Porter, B.S<sup>1</sup>, Marcheta J. Hill, DO<sup>2</sup>, Dawn L. Laporte, MD<sup>3</sup>, Amiethab A. Aiyer, MD<sup>3</sup>


<sup>1</sup>Qompass, Spokane, WA
<sup>2</sup>Arnot Ogden Medical Center Emergency Medicine Residency Program, Elmira, NY
<sup>3</sup>The Johns Hopkins University School of Medicine, Department of Orthopaedic Surgery, Baltimore, MD
## Abstract

### Title
Kyber Odyssey: Charting a course for secure research & innovation in a post-Crowdstrike world

### Background
The catastrophic Crowdstrike patch failure of July 19, 2024, exposed critical vulnerabilities in global healthcare systems, stemming from a memory safety issue in C++ code. This null pointer error, a common pitfall in languages without automatic memory management, led to system-wide failures in Microsoft-based environments while Linux/GNU and Apple systems remained unaffected. This event underscores the urgent need for robust, quantum-resistant cryptographic solutions in healthcare IT infrastructure.
### Methods
We developed a secure containerized virtual environment that implements hybrid post-quantum encryption protocol of NIST post-quantum encryption algorithm finalist Kyber1024 Key Encapsulation Mechanism (KEM) with X25519 Elliptic Curve Diffie-Hellman (ECDH) Key Exchange. Our implementation focused on two consumer grade computers  with x86_64 & aarch64 processors respectively to prioritize viability for underserved & underfunded regions. We implement our solutions using Arch and Ubuntu distributions of the Linux operating system. We compiled OpenSSL with Open Quantum Safe (OQS) support to enable post-quantum algorithms. Leveraging Podman's native rootless containerization, we created isolated environments for AI model training and inference using Miniconda3 virtual environments. This approach ensures data protection throughout the AI lifecycle while maintaining flexibility for advanced machine learning operations. We compared numerous implementations of post-quantum and classical encrption protocols as a foundation for institutions to decide for themselves on their own security protocols. 

### Results
***Adding 07/22/24

### Conclusion
We propose that our hybrid encryption protocol is a safe, secure, trustworthy solution for resposible innovation in a world of increasing technical complexity.

## References

1. [Password authenticated key exchange-based on Kyber for mobile devices](https://pubmed.ncbi.nlm.nih.gov/38660167/)
2. [Post-quantum healthcare: A roadmap for cybersecurity resilience in medical data](https://pubmed.ncbi.nlm.nih.gov/38826742/)
3. [Transitioning organizations to post-quantum cryptography](https://pubmed.ncbi.nlm.nih.gov/35546191/)

# What Releasing this software under the AGPL (Affero General Public License) means:
The software is free to use, modify, and share.
Anyone who uses the software must also share any changes they make to it.
If someone uses the software to provide a service over the internet, they must make the source code of their version available to users of that service.
This ensures that improvements and modifications to the software remain open and accessible to everyone.
It prevents companies from taking the free software, modifying it, and then selling it as a closed-source product without giving back to the community.
Users always have the right to see and modify the code of AGPL software they're using, even if it's part of an online service.
In essence, AGPL is designed to keep software free and open, especially in the age of cloud computing and web services. It encourages sharing and collaboration while protecting the original creators' intent for the software to remain open source.

# Building Kyber's Oddysey for your own responsible AI exploration

This guide will help you set up a special computer environment for AI development with advanced security features. You don't need to be a tech expert to follow these steps!

## What You'll Need

- A computer with either Windows, Mac, or Linux
- An internet connection
- Some free space on your computer (at least 10 GB recommended)

## Step-by-Step Guide

### For Windows Users

1. Install WSL2 (Windows Subsystem for Linux):
   - Open the Microsoft Store
   - Search for "Ubuntu" and install it (22.04 or 24.04 work best)
   - Follow the on-screen instructions to set it up

2. Open Ubuntu from your Start menu

3. In the Ubuntu window, type these commands:

sudo apt update
sudo apt install podman git
text
(You'll be asked for your password - type it in when prompted)

4. Get the project files:

git clone https://github.com/qompassai/K.O.
cd K.O.

5. Build the special environment:

podman build -t qompass/ko .
text
(This might take a while - it's downloading and setting up everything you need)

6. Start the environment:

podman run -it qompass/ko
text

### For Mac or Linux Users

1. Open Terminal

2. Install Podman and Git:
- For Mac:
  ```
  brew install podman git
  ```
- For Linux:
  ```
  sudo apt install podman git
  ```
  or
  ```
  sudo pacman -S podman git
  ```
  (depending on your Linux version)

3. Follow steps 4-6 from the Windows instructions above

## What to Expect

- The process might take some time, especially the building step. Be patient!
- You might see a lot of text scrolling by - that's normal.
- When it's done, you'll be in a special, secure environment for AI work.

## Need Help?

If you run into any problems:
- Make sure your internet connection is stable
- Restart your computer and try again
- Ask for help in our support forum or community chat
- This software is licensed under the 

Remember, you're setting up a complex environment, so don't worry if it doesn't work perfectly the first time. Keep trying, and don't hesitate to ask for help! 
