<!-- /qompassai/KO/README.md -->
<!-- ---------------------------- -->
<!-- Copyright (C) 2025 Qompass AI, All rights reserved -->

![Repository Views](https://komarev.com/ghpvc/?username=qompassai-KO)
![GitHub all releases](https://img.shields.io/github/downloads/qompassai/KO/total?style=flat-square)
<a href="https://www.openssl.org/">
  <img src="https://img.shields.io/badge/OpenSSL-721412?style=for-the-badge&logo=openssl&logoColor=white" alt="OpenSSL">
</a>
<br>
<a href="https://www.openssl.org/docs/">
  <img src="https://img.shields.io/badge/OpenSSL_Documentation-blue?style=flat-square" alt="OpenSSL Documentation">
</a>
<a href="https://openquantumsafe.org/">
  <img src="https://img.shields.io/badge/Post--Quantum_Tutorials-green?style=flat-square" alt="Post-Quantum SSL Tutorials">
</a>
<br>
<a href="https://www.nist.gov/">
  <img src="https://img.shields.io/badge/NIST-003366?style=for-the-badge&logo=shield&logoColor=white" alt="NIST">
</a>
<br>
<a href="https://www.nist.gov/cyberframework">
  <img src="https://img.shields.io/badge/Cybersecurity_Framework-0066CC?style=flat-square" alt="NIST Cybersecurity Framework">
</a>
<a href="https://csrc.nist.gov/publications/detail/sp/800-53/rev-5/final">
  <img src="https://img.shields.io/badge/SP_800--53-blue?style=flat-square" alt="NIST SP 800-53 Security Controls">
</a>
<a href="https://csrc.nist.gov/publications/detail/sp/800-115/final">
  <img src="https://img.shields.io/badge/SP_800--115-red?style=flat-square" alt="Technical Guide to Information Security Testing">
</a>
<br>
<a href="https://www.nist.gov/itl/applied-cybersecurity/nice">
  <img src="https://img.shields.io/badge/NICE_Framework-purple?style=flat-square" alt="NIST NICE Cybersecurity Workforce Framework">
</a>
<a href="https://csrc.nist.gov/projects/risk-management">
  <img src="https://img.shields.io/badge/Risk_Management-orange?style=flat-square" alt="NIST Risk Management Framework">
</a>
<a href="https://www.nist.gov/privacy-framework">
  <img src="https://img.shields.io/badge/Privacy_Framework-green?style=flat-square" alt="NIST Privacy Framework">
</a>
  <a href="https://www.gnu.org/licenses/agpl-3.0"><img src="https://img.shields.io/badge/License-AGPL%20v3-blue.svg" alt="License: AGPL v3"></a>
  <a href="./LICENSE-QCDA"><img src="https://img.shields.io/badge/license-Q--CDA-lightgrey.svg" alt="License: Q-CDA"></a>
</p>

<h2> Kyber Odyssey: Charting a course for secure innovation in a post-Crowdstrike world </h2>

<h3> Authors </h3>
Matt A. Porter, B.S<sup>1</sup>, Marcheta J. Hill, DO<sup>2</sup>, Dawn L. Laporte, MD<sup>3</sup>, Amiethab A. Aiyer, MD<sup>3</sup>

<sup>1</sup>Qompass, Spokane, WA  
<sup>2</sup>Arnot Ogden Medical Center Emergency Medicine Residency Program, Elmira, NY  
<sup>3</sup>The Johns Hopkins University School of Medicine, Department of Orthopaedic Surgery, Baltimore, MD

## 2025 AMA Research Challenge Poster

[Kyber Odyssey](./KO_MAP_AMA_2025_Turnin.pdf)

## Abstract

### Background
The catastrophic Crowdstrike patch failure of July 19, 2024, exposed critical vulnerabilities in global healthcare systems, stemming from a memory safety issue in C++ code. This null pointer error, a common pitfall in languages without automatic memory management, led to system-wide failures in Microsoft-based environments while Linux/GNU and Apple systems remained unaffected. This event underscores the urgent need for robust, quantum-resistant cryptographic solutions in healthcare IT infrastructure.

### Methods

We developed a protocol for building and benchmarking National Institute of
Standards and Technology (NIST)-endorsed classical and post-quantum encryption algorithms
on-premesis, using consumer grade Linux computers to prioritize viability for underserved
regions & underfunded institutions. We compiled OpenSSL with Open Quantum Safe (OQS) C
library to enable post-quantum encryption development that allowed the same level of access
as Crowdstrike's faulty driver code while allowing for bindings with numerous memory safe
programming languages. Our focus on post-quantum Key Encapsulation Mechanism (KEM)
encryption reflects the ubiqutious protection that these protocols provide to secure
communication and knowledge-work as well as the relative ease of hybridization with classical
encryption protocols like Elliptical Curve Diffie-Hellman (ECDH). Following on-device
compilation and installation of the encryption binaries, we built and executed an evaluation
script with OpenSSL's native toolkit for twenty-four NIST-endorsed KEM protocols consisting of
classical, quantum, and hybrid KEM implementations. We evaluated the KEMs on the number
and rate of key generations (keygen), key encapsulation (encap) rate, and key decapsulations
(decap) and rated their NIST post-quantum security level according to NIST advanced
encryption standard (AES) exaustic key search levels. 

### Results

We successfully benchmarked all 24 KEM protocols, producing an example
public/private key pair following the evaluation. The 24 KEM protocols are evenly split across
NIST security levels 1, 3, and 5, with 8 protocols at each.We made all relevant code, regulatory
information, and the example cryptographic key pairs available on the Qompass AI Github page.
We released them under the GNU Affero General Public License (AGPL) to maintain the free
availability of these encryption tools to benefit communities.

# Kyber Odyssey Cryptographic Security Benchmark

| Algorithm | Type | NIST Security Level | Keygen (ms) | Encaps (ms) | Decaps (ms) | Keygens/s | Encaps/s | Decaps/s | Industry/Healthcare Usage |
|:---------:|:----:|:-------------------:|:-----------:|:-----------:|:-----------:|:---------:|:--------:|:--------:|:------------------------:|
| [Frodo640AES](https://frodokem.org/) | Quantum | [Level 1](#security-levels) | 0.361 | 0.503 | 0.481 | 2773.0 | 1988.9 | 2081.0 | [Experimental in IoT](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6891283/) |
| [Frodo640SHAKE](https://frodokem.org/) | Quantum | [Level 1](#security-levels) | 2.240 | 2.364 | 2.346 | 446.5 | 423.0 | 426.3 | [Research in secure messaging](https://eprint.iacr.org/2019/1356.pdf) |
| [Frodo976AES](https://frodokem.org/) | Quantum | [Level 3](#security-levels) | 0.802 | 1.024 | 1.038 | 1247.0 | 976.8 | 963.6 | [Tested in satellite communications](https://ieeexplore.ieee.org/document/9435499) |
| [Frodo976SHAKE](https://frodokem.org/) | Quantum | [Level 3](#security-levels) | 4.975 | 5.208 | 5.128 | 201.0 | 192.0 | 195.0 | [Evaluated for financial services](https://eprint.iacr.org/2019/1356.pdf) |
| [Frodo1344AES](https://frodokem.org/) | Quantum | [Level 5](#security-levels) | 1.350 | 1.656 | 1.599 | 741.0 | 604.0 | 625.3 | [Considered for long-term data protection](https://csrc.nist.gov/Projects/post-quantum-cryptography/round-3-submissions) |
| [Frodo1344SHAKE](https://frodokem.org/) | Quantum | [Level 5](#security-levels) | 8.772 | 9.174 | 9.009 | 114.0 | 109.0 | 111.0 | [Evaluated for government communications](https://csrc.nist.gov/Projects/post-quantum-cryptography/round-3-submissions) |
| [Kyber512](https://pq-crystals.org/kyber/) | Quantum | [Level 1](#security-levels) | 0.022 | 0.021 | 0.017 | 44556.1 | 47830.3 | 58718.0 | [Implemented in VPN services](https://www.openvpn.net/cloud-docs/openvpn-3-client-for-linux/) |
| [Kyber768](https://pq-crystals.org/kyber/) | Quantum | [Level 3](#security-levels) | 0.033 | 0.032 | 0.028 | 30291.8 | 31060.6 | 36305.1 | [Tested in banking systems](https://www.ibm.com/blogs/research/2020/08/ibm-z15-quantum-safe-cryptography/) |
| [Kyber1024](https://pq-crystals.org/kyber/) | Quantum | [Level 5](#security-levels) | 0.045 | 0.045 | 0.040 | 22293.9 | 22075.8 | 24937.0 | [Evaluated for aerospace industry](https://www.esa.int/Enabling_Support/Space_Engineering_Technology/Quantum-safe_cryptography_for_space_missions) |
| [MLKEM512](https://csrc.nist.gov/Projects/post-quantum-cryptography/selected-algorithms-2022) | Quantum | [Level 1](#security-levels) | 0.022 | 0.017 | 0.017 | 45416.2 | 59462.2 | 57611.1 | [Research in smart home devices](https://ieeexplore.ieee.org/document/9311932) |
| [MLKEM768](https://csrc.nist.gov/Projects/post-quantum-cryptography/selected-algorithms-2022) | Quantum | [Level 3](#security-levels) | 0.036 | 0.027 | 0.027 | 28046.4 | 36703.0 | 37677.8 | [Evaluated for telemedicine platforms](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC7779191/) |
| [MLKEM1024](https://csrc.nist.gov/Projects/post-quantum-cryptography/selected-algorithms-2022) | Quantum | [Level 5](#security-levels) | 0.045 | 0.040 | 0.042 | 22468.7 | 24869.7 | 23599.0 | [Considered for national defense networks](https://www.nsa.gov/Press-Room/News-Highlights/Article/Article/2696916/nsa-releases-future-quantum-resistant-qr-algorithm-requirements-for-national-se/) |
| [BIKE-L1](https://bikesuite.org/) | Quantum | [Level 1](#security-levels) | 0.219 | 0.045 | 0.733 | 4556.0 | 22061.6 | 1364.6 | [Experimental in IoT networks](https://ieeexplore.ieee.org/document/9311932) |
| [BIKE-L3](https://bikesuite.org/) | Quantum | [Level 3](#security-levels) | 0.631 | 0.107 | 2.404 | 1586.0 | 9351.5 | 416.0 | [Research in industrial control systems](https://www.mdpi.com/1424-8220/21/15/5247) |
| [BIKE-L5](https://bikesuite.org/) | Quantum | [Level 5](#security-levels) | 1.658 | 0.243 | 5.657 | 603.0 | 4123.0 | 176.8 | [Evaluated for long-term data archiving](https://csrc.nist.gov/Projects/post-quantum-cryptography/round-3-submissions) |
| [HQC-128](https://pqc-hqc.org/) | Quantum | [Level 1](#security-levels) | 1.828 | 3.613 | 5.882 | 547.0 | 276.8 | 170.0 | [Research in wearable tech security](https://www.mdpi.com/1424-8220/21/15/5247) |
| [HQC-192](https://pqc-hqc.org/) | Quantum | [Level 3](#security-levels) | 5.525 | 10.989 | 16.949 | 181.0 | 91.0 | 59.0 | [Evaluated for healthcare data exchange](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC7779191/) |
| [HQC-256](https://pqc-hqc.org/) | Quantum | [Level 5](#security-levels) | 10.000 | 21.277 | 31.250 | 100.0 | 47.0 | 32.0 | [Considered for military communications](https://www.nsa.gov/Press-Room/News-Highlights/Article/Article/2696916/nsa-releases-future-quantum-resistant-qr-algorithm-requirements-for-national-se/) |
| [P-256 + Kyber512](https://www.nccoe.nist.gov/sites/default/files/2023-12/pqc-migration-nist-sp-1800-38c-preliminary-draft.pdf) | Hybrid | [Level 1](#security-levels) | 0.771 | 0.162 | 0.376 | 1296.9 | 6183.8 | 2658.2 | [Tested in e-commerce platforms](https://aws.amazon.com/blogs/security/how-to-tune-tls-for-hybrid-post-quantum-cryptography-with-kyber/) |
| [P-384 + Kyber768](https://www.nccoe.nist.gov/sites/default/files/2023-12/pqc-migration-nist-sp-1800-38c-preliminary-draft.pdf) | Hybrid | [Level 3](#security-levels) | 1.070 | 1.071 | 1.119 | 934.3 | 933.3 | 894.0 | [Evaluated for cloud storage services](https://aws.amazon.com/blogs/security/how-to-tune-tls-for-hybrid-post-quantum-cryptography-with-kyber/) |
| [P-521 + Kyber1024](https://www.nccoe.nist.gov/sites/default/files/2023-12/pqc-migration-nist-sp-1800-38c-preliminary-draft.pdf) | Hybrid | [Level 5](#security-levels) | 0.959 | 0.991 | 1.061 | 1042.9 | 1009.1 | 942.4 | [Research in quantum-resistant blockchains](https://arxiv.org/abs/2305.02739) |
| [X25519 + Kyber512](https://www.nccoe.nist.gov/sites/default/files/2023-12/pqc-migration-nist-sp-1800-38c-preliminary-draft.pdf) | Hybrid | [Level 1](#security-levels) | 0.071 | 0.105 | 0.099 | 14135.7 | 9543.4 | 10106.1 | [Implemented in secure messaging apps](https://signal.org/blog/pqxdh/) |
| [X25519 + Kyber768](https://www.nccoe.nist.gov/sites/default/files/2023-12/pqc-migration-nist-sp-1800-38c-preliminary-draft.pdf) | Hybrid | [Level 3](#security-levels) | 0.086 | 0.115 | 0.111 | 11621.4 | 8704.0 | 9040.0 | [Evaluated for VPN services](https://www.openvpn.net/cloud-docs/openvpn-3-client-for-linux/) |
| [X448 + Kyber768](https://www.nccoe.nist.gov/sites/default/files/2023-12/pqc-migration-nist-sp-1800-38c-preliminary-draft.pdf) | Hybrid | [Level 3](#security-levels) | 0.274 | 0.487 | 0.491 | 3644.9 | 2055.1 | 2037.4 | [Research in high-security financial systems](https://eprint.iacr.org/2019/1356.pdf) |
## Legend

| Term | Explanation | Security Implication |
|:----:|:-----------:|:--------------------:|
| Algorithm | The name of the encryption method used to secure data | N/A |
| NIST Security Level | Indicates the level of security as defined by NIST | Higher is more secure |
| Keygen (ms) | Time taken to generate a key pair (in milliseconds) | Lower is generally better, but too low may indicate weakness |
| Encaps (ms) | Time taken to encapsulate (encrypt) a shared secret (in milliseconds) | Lower is better for performance, but should balance with security |
| Decaps (ms) | Time taken to decapsulate (decrypt) a shared secret (in milliseconds) | Lower is better for performance, but should balance with security |
| Keygens/s | Number of key pairs that can be generated per second | Higher is better for performance, but should balance with security |
| Encaps/s | Number of encapsulations that can be performed per second | Higher is better for performance, but should balance with security |
| Decaps/s | Number of decapsulations that can be performed per second | Higher is better for performance, but should balance with security |
| Industry/Healthcare Usage | Examples of current or potential use in industry or healthcare | N/A |

## Security Levels

| Level | Description | Healthcare Example |
|:-----:|:-----------:|:------------------:|
| [Level 1](https://blog.cloudflare.com/pq-2024) | At least as hard to break as AES-128 | [Securing patient portals](https://www.healthit.gov/topic/privacy-security-and-hipaa/security-risk-assessment-tool) |
| [Level 3](https://csrc.nist.gov/Projects/post-quantum-cryptography/faqs) | At least as hard to break as AES-192 | [Protecting electronic health records (EHRs)](https://www.hhs.gov/hipaa/for-professionals/security/guidance/cybersecurity/index.html) |
| [Level 5](https://csrc.nist.gov/CSRC/media/Presentations/Let-s-Get-Ready-to-Rumble-The-NIST-PQC-Competiti/images-media/PQCrypto-April2018_Moody.pdf) | At least as hard to break as AES-256 | [Safeguarding genomic data](https://www.genome.gov/about-genomics/policy-issues/Privacy) |

Note: While higher security levels provide stronger protection, they often come with increased computational costs. The choice of security level should be based on the sensitivity of the data and the specific requirements of the healthcare application.

### Conclusion
Out of the evaluated KEMs, we propose hybrid combinations of ECDH and Kyber for most acute adoption of enhanced encryption protocols due to the layered security of nascent post-quantum encryption with established efficient classical protocols. Currently, Google Chrome implements X25519_Kyber768 hybrid encryption as part of its Transport Layer Security (TLS), offering a familiar and accessible platform to perform institutional assessements.
## References

1. [Password authenticated key exchange-based on Kyber for mobile devices](https://pubmed.ncbi.nlm.nih.gov/38660167/)
2. [Post-quantum healthcare: A roadmap for cybersecurity resilience in medical data](https://pubmed.ncbi.nlm.nih.gov/38826742/)
3. [Transitioning organizations to post-quantum cryptography](https://pubmed.ncbi.nlm.nih.gov/35546191/)

# Acknowledgment
We would like to thank the Ruth Jackson Orthopaedic Society and Zimmer Biomet for their generous support of our work.

# Dual-License Notice
This repository and all applications within it are dual-licensed under the terms of the [Qompass Commercial Distribution Agreement (CDA)](LICENSE) and [GNU Affero General Public License v3.0 (AGPL-3.0)](LICENSE-AGPL) licenses.

## What a Dual-License means

### Protection for Vulnerable Populations

The dual licensing aims to address the cybersecurity gap that disproportionately affects underserved populations. As highlighted by recent attacks[^1], low-income residents, seniors, and foreign language speakers face higher-than-average risks of being victims of cyber attacks. By offering both open-source and commercial licensing options, we encourage the development of cybersecurity solutions that can reach these vulnerable groups while also enabling sustainable development and support.

### Preventing Malicious Use

The AGPL-3.0 license ensures that any modifications to the software remain open source, preventing bad actors from creating closed-source variants that could be used for exploitation. This is especially crucial given the rising threats to vulnerable communities, including children in educational settings. The attack on Minneapolis Public Schools, which resulted in the leak of 300,000 files and a $1 million ransom demand, highlights the importance of transparency and security[^6]).

### Addressing Cybersecurity in Critical Sectors

The commercial license option allows for tailored solutions in critical sectors such as healthcare, which has seen significant impacts from cyberattacks. For example, the recent Change Healthcare attack[^2] affected millions of Americans and caused widespread disruption for hospitals and other providers.

### Supporting Cybersecurity Awareness

The dual licensing model supports initiatives like theCybersecurity and Infrastructure Security Agency (CISA) efforts to improve cybersecurity awareness[^3] in "target rich" sectors, including K-12 education. By allowing both open-source and commercial use, we aim to facilitate the development of tools that support these critical awareness and protection efforts.

### Bridging the Digital Divide

The unfortunate reality is that a number of individuals and organizations have gone into a frenzy in every facet of our daily lives[^4]. These unfortunate folks identify themselves with their talk of "10X" returns and building towards Artificial General Intelligence aka "AGI" whiel offering GPT wrappers. Our dual licensing approach aims to acknkowledge this deeply concerning predatory paradigm witih clear eyes while still doing operating to bring the best parts of the open-source community with our services and solutions.

### Recent Cybersecurity Attacks

Recent attacks underscore the importance of robust cybersecurity measures:

- The Change Healthcare cyberattack in February 2024[^2] affected millions of Americans and caused significant disruption to healthcare providers.
- The White House and Congress jointly designated October as Cybersecurity Awareness Month[^5]. This designation comes with over 100 actions that align the Federal government and public/private sector partners are taking to help every man, woman, and child to safely navigate the age of AI. 
### Conclusion

By offering both open-source and commercial licensing options, we strive to create a balance that promotes innovation and accessibility while also providing the necessary resources and flexibility to address the complex cybersecurity challenges faced by vulnerable populations and critical infrastructure sectors.

[^1]: [International Counter Ransomware Initiative 2024 Joint Statement](https://www.whitehouse.gov/briefing-room/statements-releases/2024/10/02/international-counter-ransomware-initiative-2024-joint-statement/)
[^2]: [The Top 10 Health Data Breaches of the First Half of 2024](https://www.chiefhealthcareexecutive.com/view/the-top-10-health-data-breaches-of-the-first-half-of-2024)
[^3]: [CISA's K-12 Cybersecurity Initiatives](https://www.cisa.gov/K12Cybersecurity)
[^4]: [Federal Trade Commission Operation AI Comply: continuing the crackdown on overpromises and AI-related lies](https://www.ftc.gov/business-guidance/blog/2024/09/operation-ai-comply-continuing-crackdown-overpromises-ai-related-lies)
[^5]: [A Proclamation on Cybersecurity Awareness Month, 2024 ](https://www.whitehouse.gov/briefing-room/presidential-actions/2024/09/30/a-proclamation-on-cybersecurity-awareness-month-2024/)
[^6]: [Minneapolis school district says data breach affected more than 100,000 people](https://therecord.media/minneapolis-schools-say-data-breach-affected-100000/)
