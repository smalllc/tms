/*
Navicat MySQL Data Transfer

Source Server         : 106.13.10.121
Source Server Version : 50723
Source Host           : 106.13.10.121:3306
Source Database       : tms

Target Server Type    : MYSQL
Target Server Version : 50723
File Encoding         : 65001

Date: 2018-12-26 10:54:00
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for actor_schedule
-- ----------------------------
DROP TABLE IF EXISTS `actor_schedule`;
CREATE TABLE `actor_schedule` (
  `user_id` varchar(50) NOT NULL,
  `schedule_id` bigint(20) NOT NULL,
  PRIMARY KEY (`user_id`,`schedule_id`),
  KEY `FKot5snid2qa72h0p8joabtwdnk` (`schedule_id`),
  CONSTRAINT `FKbxoxh58bhineg8skkohehsikd` FOREIGN KEY (`user_id`) REFERENCES `users` (`username`),
  CONSTRAINT `FKot5snid2qa72h0p8joabtwdnk` FOREIGN KEY (`schedule_id`) REFERENCES `schedule` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of actor_schedule
-- ----------------------------

-- ----------------------------
-- Table structure for authorities
-- ----------------------------
DROP TABLE IF EXISTS `authorities`;
CREATE TABLE `authorities` (
  `authority` varchar(50) NOT NULL,
  `username` varchar(50) NOT NULL,
  PRIMARY KEY (`authority`,`username`),
  KEY `FKhjuy9y4fd8v5m3klig05ktofg` (`username`),
  CONSTRAINT `FKhjuy9y4fd8v5m3klig05ktofg` FOREIGN KEY (`username`) REFERENCES `users` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of authorities
-- ----------------------------
INSERT INTO `authorities` VALUES ('ROLE_USER', 'smallcc');
INSERT INTO `authorities` VALUES ('ROLE_ADMIN', 'super');
INSERT INTO `authorities` VALUES ('ROLE_SUPER', 'super');
INSERT INTO `authorities` VALUES ('ROLE_USER', 'super');

-- ----------------------------
-- Table structure for blog
-- ----------------------------
DROP TABLE IF EXISTS `blog`;
CREATE TABLE `blog` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `content` longtext,
  `create_date` datetime DEFAULT NULL,
  `editor` varchar(255) DEFAULT NULL,
  `open_edit` bit(1) DEFAULT NULL,
  `opened` bit(1) DEFAULT NULL,
  `privated` bit(1) DEFAULT NULL,
  `read_cnt` bigint(20) DEFAULT NULL,
  `status` varchar(255) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `version` bigint(20) NOT NULL,
  `vote_cai` longtext,
  `vote_cai_cnt` int(11) DEFAULT NULL,
  `vote_zan` longtext,
  `vote_zan_cnt` int(11) DEFAULT NULL,
  `creator` varchar(50) DEFAULT NULL,
  `dir` bigint(20) DEFAULT NULL,
  `space` bigint(20) DEFAULT NULL,
  `updater` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK8cwy7v9e6yktww11cq7mllq1k` (`creator`),
  KEY `FKf1m612mqe0it4vahb3bontxpx` (`dir`),
  KEY `FKdu4tkukceab6gylc5xr5wnalt` (`space`),
  KEY `FKfttfwyuckn1nlj9qm1rcnpa6r` (`updater`),
  CONSTRAINT `FK8cwy7v9e6yktww11cq7mllq1k` FOREIGN KEY (`creator`) REFERENCES `users` (`username`),
  CONSTRAINT `FKdu4tkukceab6gylc5xr5wnalt` FOREIGN KEY (`space`) REFERENCES `space` (`id`),
  CONSTRAINT `FKf1m612mqe0it4vahb3bontxpx` FOREIGN KEY (`dir`) REFERENCES `dir` (`id`),
  CONSTRAINT `FKfttfwyuckn1nlj9qm1rcnpa6r` FOREIGN KEY (`updater`) REFERENCES `users` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of blog
-- ----------------------------
INSERT INTO `blog` VALUES ('1', '\n如果你还在被HD钱包、BIP32、BIP44、BIP39搞的一头雾水，来看看这边文章吧。\n\n数字钱包概念\n钱包用来存钱的，在区块链中，我们的数字资产都会对应到一个账户地址上， 只有拥有账户的钥匙（私钥）才可以对资产进行消费（用私钥对消费交易签名）。\n私钥和地址的关系如下：\n（图来自精通比特币）\n一句话概括下就是：私钥通过椭圆曲线生成公钥， 公钥通过哈希函数生成地址，这两个过程都是单向的。\n\n因此实际上，数字钱包实际是一个管理私钥（生成、存储、签名）的工具，注意钱包并不保存资产，资产是在链上的。\n\n如何创建账号\n创建账号关键是生成一个私钥， 私钥是一个32个字节的数， 生成一个私钥在本质上在1到2^256之间选一个数字。\n因此生成密钥的第一步也是最重要的一步，是要找到足够安全的熵源，即随机性来源，只要选取的结果是不可预测或不可重复的，那么选取数字的具体方法并不重要。\n\n比如可以掷硬币256次，用纸和笔记录正反面并转换为0和1，随机得到的256位二进制数字可作为钱包的私钥。\n\n从编程的角度来看，一般是通过在一个密码学安全的随机源(不建议大家自己去写一个随机数)中取出一长串随机字节，对其使用SHA256哈希算法进行运算，这样就可以方便地产生一个256位的数字。\n\n实际过程需要比较下是否小于n-1（n = 1.158 * 10^77, 略小于2^256），我们就有了一个合适的私钥。否则，我们就用另一个随机数再重复一次。这样得到的私钥就可以根据上面的方法进一步生成公钥及地址。\n\nBIP32\n钱包也是一个私钥的容器，按照上面的方法，我们可以生成一堆私钥（一个人也有很多账号的需求，可以更好保护隐私），而每个私钥都需要备份就特别麻烦的。\n\n最早期的比特币钱包就是就是这样，还有一个昵称：“Just a Bunch Of Keys(一堆私钥)“\n\n为了解决这种麻烦，就有了BIP32 提议： 根据一个随机数种子通过分层确定性推导的方式得到n个私钥，这样保存的时候，只需要保存一个种子就可以，私钥可以推导出来，如图：\n\n\n（图来自精通比特币）上图中的孙秘钥就可以用来签发交易。\n\n补充说明下 BIP: Bitcoin Improvement Proposals 比特币改进建议, bip32是第32个改进建议。\nBIP32提案的名字是：Hierarchical Deterministic Wallets， 就是我们所说的HD钱包。\n\n来分析下这个分层推导的过程，第一步推导主秘钥的过程：\n\n\n根种子输入到HMAC-SHA512算法中就可以得到一个可用来创造主私钥(m) 和 一个主链编码（ a master chain code)这一步生成的秘钥（由私钥或公钥）及主链编码再加上一个索引号，将作为HMAC-SHA512算法的输入继续衍生出下一层的私钥及链编码，如下图：\n\n衍生推导的方案其实有两个：一个用父私钥推导（称为强化衍生方程），一个用父公钥推导。同时为了区分这两种不同的衍生，在索引号也进行了区分，索引号小于2^31用于常规衍生，而2^31到2^32-1之间用于强化衍生，为了方便表示索引号i\'，表示2^31+i。\n\n因此增加索引（水平扩展）及 通过子秘钥向下一层（深度扩展）可以无限生成私钥。\n\n注意， 这个推导过程是确定（相同的输入，总是有相同的输出）也是单向的，子密钥不能推导出同层级的兄弟密钥，也不能推出父密钥。如果没有子链码也不能推导出孙密钥。现在我们已经对分层推导有了认识。\n\n一句话概括下BIP32就是：为了避免管理一堆私钥的麻烦提出的分层推导方案。\n\n秘钥路径及BIP44\n通过这种分层（树状结构）推导出来的秘钥，通常用路径来表示，每个级别之间用斜杠 / 来表示，由主私钥衍生出的私钥起始以“m”打头。因此，第一个母密钥生成的子私钥是m/0。第一个公共钥匙是M/0。第一个子密钥的子密钥就是m/0/1，以此类推。\n\nBIP44则是为这个路径约定了一个规范的含义(也扩展了对多币种的支持)，BIP0044指定了包含5个预定义树状层级的结构：\nm / purpose\' / coin\' / account\' / change / address_index \nm是固定的, Purpose也是固定的，值为44（或者 0x8000002C）\nCoin type\n这个代表的是币种，0代表比特币，1代表比特币测试链，60代表以太坊\n完整的币种列表地址：https://github.com/satoshilabs/slips/blob/master/slip-0044.md\nAccount\n代表这个币的账户索引，从0开始\nChange\n常量0用于外部链，常量1用于内部链（也称为更改地址）。外部链用于在钱包外可见的地址（例如，用于接收付款）。内部链用于在钱包外部不可见的地址，用于返回交易变更。 (所以一般使用0)\naddress_index\n这就是地址索引，从0开始，代表生成第几个地址，官方建议，每个account下的address_index不要超过20\n\n根据 EIP85提议的讨论以太坊钱包也遵循BIP44标准，确定路径是m/44\'/60\'/a\'/0/n\na 表示帐号，n 是第 n 生成的地址，60 是在 SLIP44 提案中确定的以太坊的编码。所以我们要开发以太坊钱包同样需要对比特币的钱包提案BIP32、BIP39有所了解。\n\n一句话概括下BIP44就是：给BIP32的分层路径定义规范\n\nBIP39\nBIP32 提案可以让我们保存一个随机数种子（通常16进制数表示），而不是一堆秘钥，确实方便一些，不过用户使用起来(比如冷备份)也比较繁琐，这就出现了BIP39，它是使用助记词的方式，生成种子的，这样用户只需要记住12（或24）个单词，单词序列通过 PBKDF2 与 HMAC-SHA512 函数创建出随机种子作为 BIP32 的种子。\n\n可以简单的做一个对比，下面那一种备份起来更友好：\n\n// 随机数种子\n090ABCB3A6e1400e9345bC60c78a8BE7  \n// 助记词种子\ncandy maple cake sugar pudding cream honey rich smooth crumble sweet treat\n使用助记词作为种子其实包含2个部分：助记词生成及助记词推导出随机种子，下面分析下这个过程。\n\n生成助记词\n助记词生成的过程是这样的：先生成一个128位随机数，再加上对随机数做的校验4位，得到132位的一个数，然后按每11位做切分，这样就有了12个二进制数，然后用每个数去查BIP39定义的单词表，这样就得到12个助记词，这个过程图示如下：\n\n\n（图来源于网络）\n\n下面是使用bip39生成生成助记词的一段代码：\n\nvar bip39 = require(\'bip39\')\n// 生成助记词\nvar mnemonic = bip39.generateMnemonic()\nconsole.log(mnemonic)\n助记词推导出种子\n这个过程使用密钥拉伸（Key stretching）函数，被用来增强弱密钥的安全性，PBKDF2是常用的密钥拉伸算法中的一种。\nPBKDF2基本原理是通过一个为随机函数(例如 HMAC 函数)，把助记词明文和盐值作为输入参数，然后重复进行运算最终产生生成一个更长的（512 位）密钥种子。这个种子再构建一个确定性钱包并派生出它的密钥。\n\n密钥拉伸函数需要两个参数：助记词和盐。盐可以提高暴力破解的难度。 盐由常量字符串 \"mnemonic\" 及一个可选的密码组成，注意使用不同密码，则拉伸函数在使用同一个助记词的情况下会产生一个不同的种子，这个过程图示图下:\n\n\n（图来源于网络）\n\n同样代码来表示一下：\n\nvar hdkey = require(\'ethereumjs-wallet/hdkey\')\nvar util = require(\'ethereumjs-util\')\n\nvar seed = bip39.mnemonicToSeed(mnemonic, \"pwd\");\nvar hdWallet = hdkey.fromMasterSeed(seed);\n\nvar key1 = hdWallet.derivePath(\"m/44\'/60\'/0\'/0/0\");\nconsole.log(\"私钥：\"+util.bufferToHex(key1._hdkey._privateKey));\n\nvar address1 = util.pubToAddress(key1._hdkey._publicKey, true);\nconsole.log(\"地址：\"+util.bufferToHex(address1));\nconsole.log(\"校验和地址：\"+ util.toChecksumAddress(address1.toString(\'hex\')));\n校验和地址是EIP-55中定义的对大小写有要求的一种地址形式。\n\n密码可以作为一个额外的安全因子来保护种子，即使助记词的备份被窃取，也可以保证钱包的安全（也要求密码拥有足够的复杂度和长度），不过另外一方面，如果我们忘记密码，那么将无法恢复我们的数字资产。\n\n一句话概括下BIP39就是：通过定义助记词让种子的备份更友好\n\n我为大家录制了一个视频：以太坊去中心化网页钱包开发，从如何创建账号开始，深入探索BIP32、BIP44、BIP39等提案，以及如何存储私钥、发送离线签名交易和Token。\n\n小结\nHD钱包（Hierarchical Deterministic Wallets）是在BIP32中提出的为了避免管理一堆私钥的麻烦提出的分层推导方案。\n而BIP44是给BIP32的分层增强了路径定义规范，同时增加了对多币种的支持。\nBIP39则通过定义助记词让种子的备份更友好。\n\n目前我们的市面上单到的以太币、比特币钱包基本都遵循这些标准。\n\n最后推荐一个助记词秘钥生成器网站', '2018-12-26 10:40:22', null, '\0', '\0', '\0', '1', 'New', '理解开发HD 钱包涉及的 BIP32、BIP44、BIP39 ', 'Own', '2018-12-26 10:40:22', '0', null, null, null, null, 'super', null, null, 'super');

-- ----------------------------
-- Table structure for blog_authority
-- ----------------------------
DROP TABLE IF EXISTS `blog_authority`;
CREATE TABLE `blog_authority` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `create_date` datetime DEFAULT NULL,
  `status` varchar(255) NOT NULL,
  `update_date` datetime DEFAULT NULL,
  `version` bigint(20) NOT NULL,
  `blog` bigint(20) DEFAULT NULL,
  `channel` bigint(20) DEFAULT NULL,
  `creator` varchar(50) DEFAULT NULL,
  `updater` varchar(50) DEFAULT NULL,
  `user` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKkchrap52kwklvjmysj1wox3av` (`blog`),
  KEY `FKelx13pviq2vtbhgvlxis3clih` (`channel`),
  KEY `FK1cbc0sv3qfan210gf1nm4n4fa` (`creator`),
  KEY `FKhw1rcafu9mcuhwnqlt99xbahq` (`updater`),
  KEY `FKnqnhucobycrly7hgu6ex3wia5` (`user`),
  CONSTRAINT `FK1cbc0sv3qfan210gf1nm4n4fa` FOREIGN KEY (`creator`) REFERENCES `users` (`username`),
  CONSTRAINT `FKelx13pviq2vtbhgvlxis3clih` FOREIGN KEY (`channel`) REFERENCES `channel` (`id`),
  CONSTRAINT `FKhw1rcafu9mcuhwnqlt99xbahq` FOREIGN KEY (`updater`) REFERENCES `users` (`username`),
  CONSTRAINT `FKkchrap52kwklvjmysj1wox3av` FOREIGN KEY (`blog`) REFERENCES `blog` (`id`),
  CONSTRAINT `FKnqnhucobycrly7hgu6ex3wia5` FOREIGN KEY (`user`) REFERENCES `users` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of blog_authority
-- ----------------------------

-- ----------------------------
-- Table structure for blog_follower
-- ----------------------------
DROP TABLE IF EXISTS `blog_follower`;
CREATE TABLE `blog_follower` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `create_date` datetime DEFAULT NULL,
  `status` varchar(255) NOT NULL,
  `update_date` datetime DEFAULT NULL,
  `version` bigint(20) NOT NULL,
  `blog_id` bigint(20) DEFAULT NULL,
  `creator` varchar(50) DEFAULT NULL,
  `updater` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKii8ihblqs49jxj6ode5o6jd0t` (`blog_id`),
  KEY `FKo4ks6dank2h71tti5dpr68qqq` (`creator`),
  KEY `FKq7cr53gh5wfydvtiacy6mppxs` (`updater`),
  CONSTRAINT `FKii8ihblqs49jxj6ode5o6jd0t` FOREIGN KEY (`blog_id`) REFERENCES `blog` (`id`),
  CONSTRAINT `FKo4ks6dank2h71tti5dpr68qqq` FOREIGN KEY (`creator`) REFERENCES `users` (`username`),
  CONSTRAINT `FKq7cr53gh5wfydvtiacy6mppxs` FOREIGN KEY (`updater`) REFERENCES `users` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of blog_follower
-- ----------------------------

-- ----------------------------
-- Table structure for blog_history
-- ----------------------------
DROP TABLE IF EXISTS `blog_history`;
CREATE TABLE `blog_history` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `blog_update_date` datetime DEFAULT NULL,
  `content` longtext,
  `create_date` datetime DEFAULT NULL,
  `status` varchar(255) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `version` bigint(20) NOT NULL,
  `blog` bigint(20) DEFAULT NULL,
  `blog_updater` varchar(50) DEFAULT NULL,
  `creator` varchar(50) DEFAULT NULL,
  `updater` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKc0uds0kdb0nl97c5vycxvyfeh` (`blog`),
  KEY `FKce8xifqci30s5lv5dysnrrrfi` (`blog_updater`),
  KEY `FKq0pp4mdiy5tl448w3mayc76sr` (`creator`),
  KEY `FKenldocibtyl8myxaw151je1rw` (`updater`),
  CONSTRAINT `FKc0uds0kdb0nl97c5vycxvyfeh` FOREIGN KEY (`blog`) REFERENCES `blog` (`id`),
  CONSTRAINT `FKce8xifqci30s5lv5dysnrrrfi` FOREIGN KEY (`blog_updater`) REFERENCES `users` (`username`),
  CONSTRAINT `FKenldocibtyl8myxaw151je1rw` FOREIGN KEY (`updater`) REFERENCES `users` (`username`),
  CONSTRAINT `FKq0pp4mdiy5tl448w3mayc76sr` FOREIGN KEY (`creator`) REFERENCES `users` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of blog_history
-- ----------------------------

-- ----------------------------
-- Table structure for blog_news
-- ----------------------------
DROP TABLE IF EXISTS `blog_news`;
CREATE TABLE `blog_news` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `bid` bigint(20) DEFAULT NULL,
  `cid` bigint(20) DEFAULT NULL,
  `cmd` varchar(255) DEFAULT NULL,
  `content` varchar(255) DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `status` varchar(255) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `_to` varchar(255) DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `username` varchar(255) DEFAULT NULL,
  `version` bigint(20) NOT NULL,
  `creator` varchar(50) DEFAULT NULL,
  `updater` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKsma1marnjvxfoi2xbyp625xsb` (`creator`),
  KEY `FKjygghds7id9084ydtildvhui` (`updater`),
  CONSTRAINT `FKjygghds7id9084ydtildvhui` FOREIGN KEY (`updater`) REFERENCES `users` (`username`),
  CONSTRAINT `FKsma1marnjvxfoi2xbyp625xsb` FOREIGN KEY (`creator`) REFERENCES `users` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of blog_news
-- ----------------------------

-- ----------------------------
-- Table structure for blog_stow
-- ----------------------------
DROP TABLE IF EXISTS `blog_stow`;
CREATE TABLE `blog_stow` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `create_date` datetime DEFAULT NULL,
  `status` varchar(255) NOT NULL,
  `update_date` datetime DEFAULT NULL,
  `version` bigint(20) NOT NULL,
  `blog_id` bigint(20) DEFAULT NULL,
  `creator` varchar(50) DEFAULT NULL,
  `updater` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKih3durpy2m0o4mtbqor3mjr5q` (`blog_id`),
  KEY `FKqd02rr8noh1iuv7lramv6f7k2` (`creator`),
  KEY `FKrqywm1bwtpugai5g1wb93xubu` (`updater`),
  CONSTRAINT `FKih3durpy2m0o4mtbqor3mjr5q` FOREIGN KEY (`blog_id`) REFERENCES `blog` (`id`),
  CONSTRAINT `FKqd02rr8noh1iuv7lramv6f7k2` FOREIGN KEY (`creator`) REFERENCES `users` (`username`),
  CONSTRAINT `FKrqywm1bwtpugai5g1wb93xubu` FOREIGN KEY (`updater`) REFERENCES `users` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of blog_stow
-- ----------------------------

-- ----------------------------
-- Table structure for channel
-- ----------------------------
DROP TABLE IF EXISTS `channel`;
CREATE TABLE `channel` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `create_date` datetime DEFAULT NULL,
  `description` varchar(2000) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `privated` bit(1) DEFAULT NULL,
  `status` varchar(255) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `version` bigint(20) NOT NULL,
  `creator` varchar(50) DEFAULT NULL,
  `owner` varchar(50) DEFAULT NULL,
  `updater` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_1r44jjdpx9o6wabic55qp3mgm` (`name`),
  KEY `FKt22kgiha8cp7qvjwb4khjxitc` (`creator`),
  KEY `FKey3ru6d8ftp7ytfu2wgvqb2my` (`owner`),
  KEY `FK6nj0cuofienaubinwecc4mrea` (`updater`),
  CONSTRAINT `FK6nj0cuofienaubinwecc4mrea` FOREIGN KEY (`updater`) REFERENCES `users` (`username`),
  CONSTRAINT `FKey3ru6d8ftp7ytfu2wgvqb2my` FOREIGN KEY (`owner`) REFERENCES `users` (`username`),
  CONSTRAINT `FKt22kgiha8cp7qvjwb4khjxitc` FOREIGN KEY (`creator`) REFERENCES `users` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of channel
-- ----------------------------
INSERT INTO `channel` VALUES ('1', '2018-12-26 10:37:07', null, 'all', '\0', 'New', '全员频道', 'Common', '2018-12-26 10:37:07', '0', 'super', 'super', 'super');

-- ----------------------------
-- Table structure for channel_group
-- ----------------------------
DROP TABLE IF EXISTS `channel_group`;
CREATE TABLE `channel_group` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `create_date` datetime DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `status` varchar(255) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `version` bigint(20) NOT NULL,
  `channel` bigint(20) DEFAULT NULL,
  `creator` varchar(50) DEFAULT NULL,
  `updater` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKlms7bxrgdns9f6j495ut1ygoa` (`channel`),
  KEY `FKoe3w6oinanov0wr43k6t2fap6` (`creator`),
  KEY `FKogirjnkqhc3eoqii9mjut8am2` (`updater`),
  CONSTRAINT `FKlms7bxrgdns9f6j495ut1ygoa` FOREIGN KEY (`channel`) REFERENCES `channel` (`id`),
  CONSTRAINT `FKoe3w6oinanov0wr43k6t2fap6` FOREIGN KEY (`creator`) REFERENCES `users` (`username`),
  CONSTRAINT `FKogirjnkqhc3eoqii9mjut8am2` FOREIGN KEY (`updater`) REFERENCES `users` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of channel_group
-- ----------------------------

-- ----------------------------
-- Table structure for chat
-- ----------------------------
DROP TABLE IF EXISTS `chat`;
CREATE TABLE `chat` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `content` longtext,
  `create_date` datetime DEFAULT NULL,
  `open_edit` bit(1) DEFAULT NULL,
  `privated` bit(1) DEFAULT NULL,
  `status` varchar(255) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `version` bigint(20) NOT NULL,
  `vote_cai` longtext,
  `vote_cai_cnt` int(11) DEFAULT NULL,
  `vote_zan` longtext,
  `vote_zan_cnt` int(11) DEFAULT NULL,
  `creator` varchar(50) DEFAULT NULL,
  `updater` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK5spmj507e58d5jgwimgc3nva2` (`creator`),
  KEY `FK8a6ywoirh5cqfhmw1mj011k8t` (`updater`),
  CONSTRAINT `FK5spmj507e58d5jgwimgc3nva2` FOREIGN KEY (`creator`) REFERENCES `users` (`username`),
  CONSTRAINT `FK8a6ywoirh5cqfhmw1mj011k8t` FOREIGN KEY (`updater`) REFERENCES `users` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of chat
-- ----------------------------

-- ----------------------------
-- Table structure for chat_at
-- ----------------------------
DROP TABLE IF EXISTS `chat_at`;
CREATE TABLE `chat_at` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `create_date` datetime DEFAULT NULL,
  `status` varchar(255) NOT NULL,
  `update_date` datetime DEFAULT NULL,
  `version` bigint(20) NOT NULL,
  `at_user` varchar(50) DEFAULT NULL,
  `chat_id` bigint(20) DEFAULT NULL,
  `chat_channel_id` bigint(20) DEFAULT NULL,
  `chat_direct_id` bigint(20) DEFAULT NULL,
  `chat_reply_id` bigint(20) DEFAULT NULL,
  `creator` varchar(50) DEFAULT NULL,
  `updater` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK2ulvcbh3ut3dqj1dbpjhebv1w` (`at_user`),
  KEY `FKjfoswcyj7g51g9w1pxdldwp3h` (`chat_id`),
  KEY `FKovm15qdmgkw07pe2j1soijxsm` (`chat_channel_id`),
  KEY `FKb9a72elr57tmm7rneyi8rab25` (`chat_direct_id`),
  KEY `FKq9m5h7mjrojhfp0dej60cojkc` (`chat_reply_id`),
  KEY `FK1terhotrn88yggbm03chqy38v` (`creator`),
  KEY `FKdgf7muqnogur4wrhn0d7xcx80` (`updater`),
  CONSTRAINT `FK1terhotrn88yggbm03chqy38v` FOREIGN KEY (`creator`) REFERENCES `users` (`username`),
  CONSTRAINT `FK2ulvcbh3ut3dqj1dbpjhebv1w` FOREIGN KEY (`at_user`) REFERENCES `users` (`username`),
  CONSTRAINT `FKb9a72elr57tmm7rneyi8rab25` FOREIGN KEY (`chat_direct_id`) REFERENCES `chat_direct` (`id`),
  CONSTRAINT `FKdgf7muqnogur4wrhn0d7xcx80` FOREIGN KEY (`updater`) REFERENCES `users` (`username`),
  CONSTRAINT `FKjfoswcyj7g51g9w1pxdldwp3h` FOREIGN KEY (`chat_id`) REFERENCES `chat` (`id`),
  CONSTRAINT `FKovm15qdmgkw07pe2j1soijxsm` FOREIGN KEY (`chat_channel_id`) REFERENCES `chat_channel` (`id`),
  CONSTRAINT `FKq9m5h7mjrojhfp0dej60cojkc` FOREIGN KEY (`chat_reply_id`) REFERENCES `chat_reply` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of chat_at
-- ----------------------------

-- ----------------------------
-- Table structure for chat_channel
-- ----------------------------
DROP TABLE IF EXISTS `chat_channel`;
CREATE TABLE `chat_channel` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `content` longtext,
  `create_date` datetime DEFAULT NULL,
  `open_edit` bit(1) DEFAULT NULL,
  `status` varchar(255) NOT NULL,
  `type` varchar(255) DEFAULT NULL,
  `ua` varchar(1000) DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `version` bigint(20) NOT NULL,
  `vote_cai` longtext,
  `vote_cai_cnt` int(11) DEFAULT NULL,
  `vote_zan` longtext,
  `vote_zan_cnt` int(11) DEFAULT NULL,
  `channel` bigint(20) DEFAULT NULL,
  `creator` varchar(50) DEFAULT NULL,
  `updater` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK1w802ceeixcwwkt5anoe6qcd6` (`channel`),
  KEY `FKmcb9u3qe0weqlra0dqe1r7cms` (`creator`),
  KEY `FKe9paujpg7iag4yiqvndrq9s5p` (`updater`),
  CONSTRAINT `FK1w802ceeixcwwkt5anoe6qcd6` FOREIGN KEY (`channel`) REFERENCES `channel` (`id`),
  CONSTRAINT `FKe9paujpg7iag4yiqvndrq9s5p` FOREIGN KEY (`updater`) REFERENCES `users` (`username`),
  CONSTRAINT `FKmcb9u3qe0weqlra0dqe1r7cms` FOREIGN KEY (`creator`) REFERENCES `users` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of chat_channel
-- ----------------------------
INSERT INTO `chat_channel` VALUES ('1', '## ~频道消息播报~\n> {~smallcc} **加入**该频道!', '2018-12-26 10:42:07', null, 'New', 'Msg', null, '2018-12-26 10:42:07', '0', null, null, null, null, '1', 'smallcc', 'smallcc');

-- ----------------------------
-- Table structure for chat_channel_follower
-- ----------------------------
DROP TABLE IF EXISTS `chat_channel_follower`;
CREATE TABLE `chat_channel_follower` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `create_date` datetime DEFAULT NULL,
  `status` varchar(255) NOT NULL,
  `version` bigint(20) NOT NULL,
  `chat_channel_id` bigint(20) DEFAULT NULL,
  `creator` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKak0oueycyqcn7x956dul00qtk` (`chat_channel_id`),
  KEY `FK39pnqjgn4mefwfu491h9sbj01` (`creator`),
  CONSTRAINT `FK39pnqjgn4mefwfu491h9sbj01` FOREIGN KEY (`creator`) REFERENCES `users` (`username`),
  CONSTRAINT `FKak0oueycyqcn7x956dul00qtk` FOREIGN KEY (`chat_channel_id`) REFERENCES `chat_channel` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of chat_channel_follower
-- ----------------------------

-- ----------------------------
-- Table structure for chat_direct
-- ----------------------------
DROP TABLE IF EXISTS `chat_direct`;
CREATE TABLE `chat_direct` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `content` longtext,
  `create_date` datetime DEFAULT NULL,
  `status` varchar(255) NOT NULL,
  `ua` varchar(1000) DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `version` bigint(20) NOT NULL,
  `chat_to` varchar(50) DEFAULT NULL,
  `creator` varchar(50) DEFAULT NULL,
  `updater` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK5l5scbipdko2akjcav78c50s7` (`chat_to`),
  KEY `FK80lqdvfsxgwn7mrm12a0sd3` (`creator`),
  KEY `FKm28eu0dw1xkb5fdj6r3py6akl` (`updater`),
  CONSTRAINT `FK5l5scbipdko2akjcav78c50s7` FOREIGN KEY (`chat_to`) REFERENCES `users` (`username`),
  CONSTRAINT `FK80lqdvfsxgwn7mrm12a0sd3` FOREIGN KEY (`creator`) REFERENCES `users` (`username`),
  CONSTRAINT `FKm28eu0dw1xkb5fdj6r3py6akl` FOREIGN KEY (`updater`) REFERENCES `users` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of chat_direct
-- ----------------------------

-- ----------------------------
-- Table structure for chat_label
-- ----------------------------
DROP TABLE IF EXISTS `chat_label`;
CREATE TABLE `chat_label` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `create_date` datetime DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `status` varchar(255) NOT NULL,
  `type` varchar(255) NOT NULL,
  `version` bigint(20) NOT NULL,
  `chat_channel` bigint(20) DEFAULT NULL,
  `chat_direct` bigint(20) DEFAULT NULL,
  `creator` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKj0w81cve888e52j7ylalrous4` (`chat_channel`),
  KEY `FK8wkce3ttnwuplnmyr5110d52k` (`chat_direct`),
  KEY `FK6irxrl6a1ramxnyqdhisakjjb` (`creator`),
  CONSTRAINT `FK6irxrl6a1ramxnyqdhisakjjb` FOREIGN KEY (`creator`) REFERENCES `users` (`username`),
  CONSTRAINT `FK8wkce3ttnwuplnmyr5110d52k` FOREIGN KEY (`chat_direct`) REFERENCES `chat_direct` (`id`),
  CONSTRAINT `FKj0w81cve888e52j7ylalrous4` FOREIGN KEY (`chat_channel`) REFERENCES `chat_channel` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of chat_label
-- ----------------------------

-- ----------------------------
-- Table structure for chat_pin
-- ----------------------------
DROP TABLE IF EXISTS `chat_pin`;
CREATE TABLE `chat_pin` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `create_date` datetime DEFAULT NULL,
  `status` varchar(255) NOT NULL,
  `version` bigint(20) NOT NULL,
  `channel` bigint(20) DEFAULT NULL,
  `chat_channel` bigint(20) DEFAULT NULL,
  `creator` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKc26asdbqmiba2l7xu3chme4mc` (`channel`),
  KEY `FK2ucbpuu7dxouq9seltshw4ka6` (`chat_channel`),
  KEY `FKn1xtdofvc6uowyc8d59f9n3sa` (`creator`),
  CONSTRAINT `FK2ucbpuu7dxouq9seltshw4ka6` FOREIGN KEY (`chat_channel`) REFERENCES `chat_channel` (`id`),
  CONSTRAINT `FKc26asdbqmiba2l7xu3chme4mc` FOREIGN KEY (`channel`) REFERENCES `channel` (`id`),
  CONSTRAINT `FKn1xtdofvc6uowyc8d59f9n3sa` FOREIGN KEY (`creator`) REFERENCES `users` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of chat_pin
-- ----------------------------

-- ----------------------------
-- Table structure for chat_reply
-- ----------------------------
DROP TABLE IF EXISTS `chat_reply`;
CREATE TABLE `chat_reply` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `content` longtext,
  `create_date` datetime DEFAULT NULL,
  `status` varchar(255) NOT NULL,
  `type` varchar(255) DEFAULT NULL,
  `ua` varchar(1000) DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `version` bigint(20) NOT NULL,
  `chat_channel` bigint(20) DEFAULT NULL,
  `creator` varchar(50) DEFAULT NULL,
  `updater` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK5rb5d6wek7c7w70f1hj3c46w3` (`chat_channel`),
  KEY `FKe3jx75pqhorhlqq2faihpcdvo` (`creator`),
  KEY `FKdtnnimbgrkm72tdat5xka55a1` (`updater`),
  CONSTRAINT `FK5rb5d6wek7c7w70f1hj3c46w3` FOREIGN KEY (`chat_channel`) REFERENCES `chat_channel` (`id`),
  CONSTRAINT `FKdtnnimbgrkm72tdat5xka55a1` FOREIGN KEY (`updater`) REFERENCES `users` (`username`),
  CONSTRAINT `FKe3jx75pqhorhlqq2faihpcdvo` FOREIGN KEY (`creator`) REFERENCES `users` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of chat_reply
-- ----------------------------

-- ----------------------------
-- Table structure for chat_stow
-- ----------------------------
DROP TABLE IF EXISTS `chat_stow`;
CREATE TABLE `chat_stow` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `create_date` datetime DEFAULT NULL,
  `status` varchar(255) NOT NULL,
  `update_date` datetime DEFAULT NULL,
  `version` bigint(20) NOT NULL,
  `chat_id` bigint(20) DEFAULT NULL,
  `chat_channel_id` bigint(20) DEFAULT NULL,
  `chat_direct_id` bigint(20) DEFAULT NULL,
  `chat_reply_id` bigint(20) DEFAULT NULL,
  `creator` varchar(50) DEFAULT NULL,
  `stow_user` varchar(50) DEFAULT NULL,
  `updater` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK7diqkq3ei5ju7xnbtrvpu3wci` (`chat_id`),
  KEY `FKmait04eq5kl16il1nwbt8pp2k` (`chat_channel_id`),
  KEY `FKe12i2ngium0pctuupbedkee5u` (`chat_direct_id`),
  KEY `FK3vdkkxip1vk8ttb3r8tk27u0v` (`chat_reply_id`),
  KEY `FK1nr7137992cafk9c2ve8wwq6h` (`creator`),
  KEY `FKc8jle7chdba5jb73t6t2kjgmx` (`stow_user`),
  KEY `FKrkhy4lhejhu6kg2tjgb663yfe` (`updater`),
  CONSTRAINT `FK1nr7137992cafk9c2ve8wwq6h` FOREIGN KEY (`creator`) REFERENCES `users` (`username`),
  CONSTRAINT `FK3vdkkxip1vk8ttb3r8tk27u0v` FOREIGN KEY (`chat_reply_id`) REFERENCES `chat_reply` (`id`),
  CONSTRAINT `FK7diqkq3ei5ju7xnbtrvpu3wci` FOREIGN KEY (`chat_id`) REFERENCES `chat` (`id`),
  CONSTRAINT `FKc8jle7chdba5jb73t6t2kjgmx` FOREIGN KEY (`stow_user`) REFERENCES `users` (`username`),
  CONSTRAINT `FKe12i2ngium0pctuupbedkee5u` FOREIGN KEY (`chat_direct_id`) REFERENCES `chat_direct` (`id`),
  CONSTRAINT `FKmait04eq5kl16il1nwbt8pp2k` FOREIGN KEY (`chat_channel_id`) REFERENCES `chat_channel` (`id`),
  CONSTRAINT `FKrkhy4lhejhu6kg2tjgb663yfe` FOREIGN KEY (`updater`) REFERENCES `users` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of chat_stow
-- ----------------------------

-- ----------------------------
-- Table structure for client_details
-- ----------------------------
DROP TABLE IF EXISTS `client_details`;
CREATE TABLE `client_details` (
  `app_id` varchar(128) NOT NULL,
  `access_token_validity` int(11) DEFAULT NULL,
  `additional_information` varchar(4096) DEFAULT NULL,
  `app_secret` varchar(255) DEFAULT NULL,
  `authorities` varchar(255) DEFAULT NULL,
  `auto_approve_scopes` varchar(255) DEFAULT NULL,
  `grant_types` varchar(255) DEFAULT NULL,
  `redirect_url` varchar(255) DEFAULT NULL,
  `refresh_token_validity` int(11) DEFAULT NULL,
  `resource_ids` varchar(255) DEFAULT NULL,
  `scope` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`app_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of client_details
-- ----------------------------

-- ----------------------------
-- Table structure for comment
-- ----------------------------
DROP TABLE IF EXISTS `comment`;
CREATE TABLE `comment` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `content` longtext,
  `create_date` datetime DEFAULT NULL,
  `status` varchar(255) NOT NULL,
  `target_id` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `version` bigint(20) NOT NULL,
  `vote_cai` longtext,
  `vote_cai_cnt` int(11) DEFAULT NULL,
  `vote_zan` longtext,
  `vote_zan_cnt` int(11) DEFAULT NULL,
  `creator` varchar(50) DEFAULT NULL,
  `updater` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKp81hskifqrnh5bmo521l3drjx` (`creator`),
  KEY `FK97j2rtftxx8dyyweuumsnufiq` (`updater`),
  CONSTRAINT `FK97j2rtftxx8dyyweuumsnufiq` FOREIGN KEY (`updater`) REFERENCES `users` (`username`),
  CONSTRAINT `FKp81hskifqrnh5bmo521l3drjx` FOREIGN KEY (`creator`) REFERENCES `users` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of comment
-- ----------------------------

-- ----------------------------
-- Table structure for dir
-- ----------------------------
DROP TABLE IF EXISTS `dir`;
CREATE TABLE `dir` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `create_date` datetime DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `opened` bit(1) DEFAULT NULL,
  `privated` bit(1) DEFAULT NULL,
  `status` varchar(255) NOT NULL,
  `update_date` datetime DEFAULT NULL,
  `version` bigint(20) NOT NULL,
  `creator` varchar(50) DEFAULT NULL,
  `space_id` bigint(20) DEFAULT NULL,
  `updater` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKpb3u7kkgjbb0weetxjixytqh6` (`creator`),
  KEY `FKc053x8m30s98igxba2hunou4c` (`space_id`),
  KEY `FK8jmako8jinxysqtov2v5me1mm` (`updater`),
  CONSTRAINT `FK8jmako8jinxysqtov2v5me1mm` FOREIGN KEY (`updater`) REFERENCES `users` (`username`),
  CONSTRAINT `FKc053x8m30s98igxba2hunou4c` FOREIGN KEY (`space_id`) REFERENCES `space` (`id`),
  CONSTRAINT `FKpb3u7kkgjbb0weetxjixytqh6` FOREIGN KEY (`creator`) REFERENCES `users` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of dir
-- ----------------------------

-- ----------------------------
-- Table structure for feedback
-- ----------------------------
DROP TABLE IF EXISTS `feedback`;
CREATE TABLE `feedback` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `content` longtext,
  `create_date` datetime DEFAULT NULL,
  `mail` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `status` varchar(255) NOT NULL,
  `url` varchar(255) DEFAULT NULL,
  `username` varchar(255) NOT NULL,
  `version` bigint(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of feedback
-- ----------------------------

-- ----------------------------
-- Table structure for file
-- ----------------------------
DROP TABLE IF EXISTS `file`;
CREATE TABLE `file` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `create_date` datetime DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `path` varchar(255) NOT NULL,
  `status` varchar(255) NOT NULL,
  `to_id` varchar(255) DEFAULT NULL,
  `to_type` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `username` varchar(255) NOT NULL,
  `uuid_name` varchar(255) NOT NULL,
  `version` bigint(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of file
-- ----------------------------

-- ----------------------------
-- Table structure for file_translate
-- ----------------------------
DROP TABLE IF EXISTS `file_translate`;
CREATE TABLE `file_translate` (
  `file_id` bigint(20) NOT NULL,
  `translate_id` bigint(20) NOT NULL,
  PRIMARY KEY (`file_id`,`translate_id`),
  KEY `FKq9hch7cfihkew4ng6951rppub` (`translate_id`),
  CONSTRAINT `FK8tit8kt54b6e8sl3nna4q5fiq` FOREIGN KEY (`file_id`) REFERENCES `file` (`id`),
  CONSTRAINT `FKq9hch7cfihkew4ng6951rppub` FOREIGN KEY (`translate_id`) REFERENCES `translate` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of file_translate
-- ----------------------------

-- ----------------------------
-- Table structure for groups
-- ----------------------------
DROP TABLE IF EXISTS `groups`;
CREATE TABLE `groups` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `create_date` datetime DEFAULT NULL,
  `creator` varchar(255) DEFAULT NULL,
  `group_name` varchar(50) NOT NULL,
  `status` varchar(255) NOT NULL,
  `update_date` datetime DEFAULT NULL,
  `updater` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of groups
-- ----------------------------

-- ----------------------------
-- Table structure for group_authorities
-- ----------------------------
DROP TABLE IF EXISTS `group_authorities`;
CREATE TABLE `group_authorities` (
  `authority` varchar(50) NOT NULL,
  `group_id` bigint(20) NOT NULL,
  PRIMARY KEY (`authority`,`group_id`),
  KEY `FKruy9mx1ch59gog4lw18kgnd67` (`group_id`),
  CONSTRAINT `FKruy9mx1ch59gog4lw18kgnd67` FOREIGN KEY (`group_id`) REFERENCES `groups` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of group_authorities
-- ----------------------------

-- ----------------------------
-- Table structure for group_members
-- ----------------------------
DROP TABLE IF EXISTS `group_members`;
CREATE TABLE `group_members` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `create_date` datetime DEFAULT NULL,
  `creator` varchar(255) DEFAULT NULL,
  `status` varchar(255) NOT NULL,
  `update_date` datetime DEFAULT NULL,
  `updater` varchar(255) DEFAULT NULL,
  `username` varchar(50) NOT NULL,
  `group_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKkv9vlrye4rmhqjq4qohy2n5a6` (`group_id`),
  CONSTRAINT `FKkv9vlrye4rmhqjq4qohy2n5a6` FOREIGN KEY (`group_id`) REFERENCES `groups` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of group_members
-- ----------------------------

-- ----------------------------
-- Table structure for label
-- ----------------------------
DROP TABLE IF EXISTS `label`;
CREATE TABLE `label` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `create_date` datetime DEFAULT NULL,
  `creator` varchar(255) DEFAULT NULL,
  `description` varchar(2000) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `status` varchar(255) NOT NULL,
  `update_date` datetime DEFAULT NULL,
  `updater` varchar(255) DEFAULT NULL,
  `version` bigint(20) NOT NULL,
  `chat_id` bigint(20) DEFAULT NULL,
  `translate_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK2sfemuww7kypmw68vcq72pom9` (`chat_id`),
  KEY `FKcaq5p8jlhy2t2b4ff9coqy9nj` (`translate_id`),
  CONSTRAINT `FK2sfemuww7kypmw68vcq72pom9` FOREIGN KEY (`chat_id`) REFERENCES `chat` (`id`),
  CONSTRAINT `FKcaq5p8jlhy2t2b4ff9coqy9nj` FOREIGN KEY (`translate_id`) REFERENCES `translate` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of label
-- ----------------------------

-- ----------------------------
-- Table structure for language
-- ----------------------------
DROP TABLE IF EXISTS `language`;
CREATE TABLE `language` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `create_date` datetime DEFAULT NULL,
  `creator` varchar(255) DEFAULT NULL,
  `description` varchar(2000) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `status` varchar(255) NOT NULL,
  `version` bigint(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of language
-- ----------------------------
INSERT INTO `language` VALUES ('1', '2018-12-26 10:37:07', 'super', '英语', 'en', 'Normal', '1');
INSERT INTO `language` VALUES ('2', '2018-12-26 10:37:07', 'super', '中文', 'zh', 'Normal', '1');

-- ----------------------------
-- Table structure for language_project
-- ----------------------------
DROP TABLE IF EXISTS `language_project`;
CREATE TABLE `language_project` (
  `language_id` bigint(20) NOT NULL,
  `project_id` bigint(20) NOT NULL,
  PRIMARY KEY (`language_id`,`project_id`),
  KEY `FKerkocimcpeurllj1f8qu30m2v` (`project_id`),
  CONSTRAINT `FKerkocimcpeurllj1f8qu30m2v` FOREIGN KEY (`project_id`) REFERENCES `project` (`id`),
  CONSTRAINT `FKkmowi08xntth1x193psndm4rc` FOREIGN KEY (`language_id`) REFERENCES `language` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of language_project
-- ----------------------------
INSERT INTO `language_project` VALUES ('1', '1');
INSERT INTO `language_project` VALUES ('2', '1');

-- ----------------------------
-- Table structure for link
-- ----------------------------
DROP TABLE IF EXISTS `link`;
CREATE TABLE `link` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `channel_id` bigint(20) DEFAULT NULL,
  `count` bigint(20) DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `href` varchar(255) DEFAULT NULL,
  `status` varchar(255) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `type` varchar(255) NOT NULL,
  `update_date` datetime DEFAULT NULL,
  `version` bigint(20) NOT NULL,
  `creator` varchar(50) DEFAULT NULL,
  `updater` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK14iqejf3y6ygtr0trw5f7hqro` (`creator`),
  KEY `FK2ng0u4mqeo67fw3rvbwy9moh5` (`updater`),
  CONSTRAINT `FK14iqejf3y6ygtr0trw5f7hqro` FOREIGN KEY (`creator`) REFERENCES `users` (`username`),
  CONSTRAINT `FK2ng0u4mqeo67fw3rvbwy9moh5` FOREIGN KEY (`updater`) REFERENCES `users` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of link
-- ----------------------------

-- ----------------------------
-- Table structure for log
-- ----------------------------
DROP TABLE IF EXISTS `log`;
CREATE TABLE `log` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `action` varchar(255) NOT NULL,
  `create_date` datetime DEFAULT NULL,
  `new_value` longtext,
  `old_value` longtext,
  `properties` varchar(255) DEFAULT NULL,
  `status` varchar(255) NOT NULL,
  `target` varchar(255) NOT NULL,
  `target_id` varchar(255) DEFAULT NULL,
  `version` bigint(20) NOT NULL,
  `creator` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKh1b7b2sxqumc05bguitjixj4d` (`creator`),
  CONSTRAINT `FKh1b7b2sxqumc05bguitjixj4d` FOREIGN KEY (`creator`) REFERENCES `users` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of log
-- ----------------------------
INSERT INTO `log` VALUES ('1', 'Create', '2018-12-26 10:40:22', '理解开发HD 钱包涉及的 BIP32、BIP44、BIP39 ', null, null, 'Normal', 'Blog', '1', '0', 'super');

-- ----------------------------
-- Table structure for member_channel
-- ----------------------------
DROP TABLE IF EXISTS `member_channel`;
CREATE TABLE `member_channel` (
  `user_id` varchar(50) NOT NULL,
  `channel_id` bigint(20) NOT NULL,
  PRIMARY KEY (`user_id`,`channel_id`),
  KEY `FKnhegdl3fba2grbloum2j38qtf` (`channel_id`),
  CONSTRAINT `FKb475pqsun6phxuwqaq2gpofpa` FOREIGN KEY (`user_id`) REFERENCES `users` (`username`),
  CONSTRAINT `FKnhegdl3fba2grbloum2j38qtf` FOREIGN KEY (`channel_id`) REFERENCES `channel` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of member_channel
-- ----------------------------
INSERT INTO `member_channel` VALUES ('smallcc', '1');
INSERT INTO `member_channel` VALUES ('super', '1');

-- ----------------------------
-- Table structure for member_channel_group
-- ----------------------------
DROP TABLE IF EXISTS `member_channel_group`;
CREATE TABLE `member_channel_group` (
  `user_id` varchar(50) NOT NULL,
  `channel_group_id` bigint(20) NOT NULL,
  PRIMARY KEY (`user_id`,`channel_group_id`),
  KEY `FKdrwk794tltcwas59jjrnihdnd` (`channel_group_id`),
  CONSTRAINT `FKc0fj5x93j82mfthmg2378quf3` FOREIGN KEY (`user_id`) REFERENCES `users` (`username`),
  CONSTRAINT `FKdrwk794tltcwas59jjrnihdnd` FOREIGN KEY (`channel_group_id`) REFERENCES `channel_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of member_channel_group
-- ----------------------------

-- ----------------------------
-- Table structure for oauth_access_token
-- ----------------------------
DROP TABLE IF EXISTS `oauth_access_token`;
CREATE TABLE `oauth_access_token` (
  `authentication_id` varchar(128) NOT NULL,
  `authentication` longblob,
  `client_id` varchar(255) DEFAULT NULL,
  `refresh_token` varchar(255) DEFAULT NULL,
  `token` longblob,
  `token_id` varchar(255) DEFAULT NULL,
  `user_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`authentication_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of oauth_access_token
-- ----------------------------

-- ----------------------------
-- Table structure for oauth_approvals
-- ----------------------------
DROP TABLE IF EXISTS `oauth_approvals`;
CREATE TABLE `oauth_approvals` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `client_id` varchar(255) DEFAULT NULL,
  `expires_at` datetime DEFAULT NULL,
  `last_modified_at` datetime DEFAULT NULL,
  `scope` varchar(255) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `user_id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of oauth_approvals
-- ----------------------------

-- ----------------------------
-- Table structure for oauth_client_details
-- ----------------------------
DROP TABLE IF EXISTS `oauth_client_details`;
CREATE TABLE `oauth_client_details` (
  `client_id` varchar(128) NOT NULL,
  `access_token_validity` int(11) DEFAULT NULL,
  `additional_information` varchar(4096) DEFAULT NULL,
  `authorities` varchar(255) DEFAULT NULL,
  `authorized_grant_types` varchar(255) DEFAULT NULL,
  `autoapprove` varchar(255) DEFAULT NULL,
  `client_secret` varchar(255) DEFAULT NULL,
  `refresh_token_validity` int(11) DEFAULT NULL,
  `resource_ids` varchar(255) DEFAULT NULL,
  `scope` varchar(255) DEFAULT NULL,
  `web_server_redirect_uri` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`client_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of oauth_client_details
-- ----------------------------

-- ----------------------------
-- Table structure for oauth_client_token
-- ----------------------------
DROP TABLE IF EXISTS `oauth_client_token`;
CREATE TABLE `oauth_client_token` (
  `authentication_id` varchar(128) NOT NULL,
  `client_id` varchar(255) DEFAULT NULL,
  `token` longblob,
  `token_id` varchar(255) DEFAULT NULL,
  `user_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`authentication_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of oauth_client_token
-- ----------------------------

-- ----------------------------
-- Table structure for oauth_code
-- ----------------------------
DROP TABLE IF EXISTS `oauth_code`;
CREATE TABLE `oauth_code` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `authentication` longblob,
  `code` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of oauth_code
-- ----------------------------

-- ----------------------------
-- Table structure for oauth_refresh_token
-- ----------------------------
DROP TABLE IF EXISTS `oauth_refresh_token`;
CREATE TABLE `oauth_refresh_token` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `authentication` longblob,
  `token` longblob,
  `token_id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of oauth_refresh_token
-- ----------------------------

-- ----------------------------
-- Table structure for persistent_logins
-- ----------------------------
DROP TABLE IF EXISTS `persistent_logins`;
CREATE TABLE `persistent_logins` (
  `series` varchar(64) NOT NULL,
  `last_used` datetime NOT NULL,
  `token` varchar(64) NOT NULL,
  `username` varchar(64) NOT NULL,
  PRIMARY KEY (`series`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of persistent_logins
-- ----------------------------

-- ----------------------------
-- Table structure for project
-- ----------------------------
DROP TABLE IF EXISTS `project`;
CREATE TABLE `project` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `create_date` datetime DEFAULT NULL,
  `creator` varchar(255) DEFAULT NULL,
  `description` varchar(2000) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `status` varchar(255) NOT NULL,
  `update_date` datetime DEFAULT NULL,
  `updater` varchar(255) DEFAULT NULL,
  `version` bigint(20) NOT NULL,
  `language_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKdjl7re0dh0b62kp5he2f6bdus` (`language_id`),
  CONSTRAINT `FKdjl7re0dh0b62kp5he2f6bdus` FOREIGN KEY (`language_id`) REFERENCES `language` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of project
-- ----------------------------
INSERT INTO `project` VALUES ('1', '2018-12-26 10:37:07', 'super', '演示项目', 'DEMO', 'Normal', null, null, '0', '1');

-- ----------------------------
-- Table structure for schedule
-- ----------------------------
DROP TABLE IF EXISTS `schedule`;
CREATE TABLE `schedule` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `create_date` datetime DEFAULT NULL,
  `description` varchar(2000) DEFAULT NULL,
  `end_date` datetime DEFAULT NULL,
  `know_status` varchar(255) DEFAULT NULL,
  `place` varchar(255) DEFAULT NULL,
  `priority` varchar(255) DEFAULT NULL,
  `privated` bit(1) DEFAULT NULL,
  `remind` bigint(20) DEFAULT NULL,
  `start_date` datetime DEFAULT NULL,
  `status` varchar(255) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `version` bigint(20) NOT NULL,
  `channel` bigint(20) DEFAULT NULL,
  `creator` varchar(50) DEFAULT NULL,
  `updater` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKr2vba38i0vuts0t43u3egydw1` (`channel`),
  KEY `FK262ve5drltk3vyfwc4qrx7vbe` (`creator`),
  KEY `FKj5cat8wn691fypx38qshdjr7r` (`updater`),
  CONSTRAINT `FK262ve5drltk3vyfwc4qrx7vbe` FOREIGN KEY (`creator`) REFERENCES `users` (`username`),
  CONSTRAINT `FKj5cat8wn691fypx38qshdjr7r` FOREIGN KEY (`updater`) REFERENCES `users` (`username`),
  CONSTRAINT `FKr2vba38i0vuts0t43u3egydw1` FOREIGN KEY (`channel`) REFERENCES `channel` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of schedule
-- ----------------------------

-- ----------------------------
-- Table structure for setting
-- ----------------------------
DROP TABLE IF EXISTS `setting`;
CREATE TABLE `setting` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `content` longtext,
  `create_date` datetime DEFAULT NULL,
  `setting_type` varchar(255) NOT NULL,
  `status` varchar(255) NOT NULL,
  `update_date` datetime DEFAULT NULL,
  `version` bigint(20) NOT NULL,
  `creator` varchar(50) DEFAULT NULL,
  `updater` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKp9ka2a82e0usivoyrcr2s2v8c` (`creator`),
  KEY `FKmmta42hre4wx04ubiarc8l8ty` (`updater`),
  CONSTRAINT `FKmmta42hre4wx04ubiarc8l8ty` FOREIGN KEY (`updater`) REFERENCES `users` (`username`),
  CONSTRAINT `FKp9ka2a82e0usivoyrcr2s2v8c` FOREIGN KEY (`creator`) REFERENCES `users` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of setting
-- ----------------------------

-- ----------------------------
-- Table structure for space
-- ----------------------------
DROP TABLE IF EXISTS `space`;
CREATE TABLE `space` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `create_date` datetime DEFAULT NULL,
  `description` longtext,
  `name` varchar(255) DEFAULT NULL,
  `opened` bit(1) DEFAULT NULL,
  `privated` bit(1) DEFAULT NULL,
  `status` varchar(255) NOT NULL,
  `type` varchar(255) DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `version` bigint(20) NOT NULL,
  `creator` varchar(50) DEFAULT NULL,
  `updater` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK1xeqc5lrcqbd13tub4pslcihg` (`creator`),
  KEY `FKe8ixqbv9q7kxp6a7d1hst9isk` (`updater`),
  CONSTRAINT `FK1xeqc5lrcqbd13tub4pslcihg` FOREIGN KEY (`creator`) REFERENCES `users` (`username`),
  CONSTRAINT `FKe8ixqbv9q7kxp6a7d1hst9isk` FOREIGN KEY (`updater`) REFERENCES `users` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of space
-- ----------------------------

-- ----------------------------
-- Table structure for space_authority
-- ----------------------------
DROP TABLE IF EXISTS `space_authority`;
CREATE TABLE `space_authority` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `create_date` datetime DEFAULT NULL,
  `status` varchar(255) NOT NULL,
  `update_date` datetime DEFAULT NULL,
  `version` bigint(20) NOT NULL,
  `channel` bigint(20) DEFAULT NULL,
  `creator` varchar(50) DEFAULT NULL,
  `space` bigint(20) DEFAULT NULL,
  `updater` varchar(50) DEFAULT NULL,
  `user` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK99mf9rh2lhek0jxlvv4ok19df` (`channel`),
  KEY `FKglu6xlqgo688g133y8h4jj80o` (`creator`),
  KEY `FKdr37cls8s1gu6njg3e3ghdbsv` (`space`),
  KEY `FKi68a7iaa1ac7bcn0212ajlqjk` (`updater`),
  KEY `FK6m238e8c4cn9tfnusk00ah0qn` (`user`),
  CONSTRAINT `FK6m238e8c4cn9tfnusk00ah0qn` FOREIGN KEY (`user`) REFERENCES `users` (`username`),
  CONSTRAINT `FK99mf9rh2lhek0jxlvv4ok19df` FOREIGN KEY (`channel`) REFERENCES `channel` (`id`),
  CONSTRAINT `FKdr37cls8s1gu6njg3e3ghdbsv` FOREIGN KEY (`space`) REFERENCES `space` (`id`),
  CONSTRAINT `FKglu6xlqgo688g133y8h4jj80o` FOREIGN KEY (`creator`) REFERENCES `users` (`username`),
  CONSTRAINT `FKi68a7iaa1ac7bcn0212ajlqjk` FOREIGN KEY (`updater`) REFERENCES `users` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of space_authority
-- ----------------------------

-- ----------------------------
-- Table structure for subscriber_channel
-- ----------------------------
DROP TABLE IF EXISTS `subscriber_channel`;
CREATE TABLE `subscriber_channel` (
  `user_id` varchar(50) NOT NULL,
  `channel_id` bigint(20) NOT NULL,
  PRIMARY KEY (`user_id`,`channel_id`),
  KEY `FKma820do5t930ixr9sbmce4emc` (`channel_id`),
  CONSTRAINT `FKlvlvey5hnjali8g72gspby2xk` FOREIGN KEY (`user_id`) REFERENCES `users` (`username`),
  CONSTRAINT `FKma820do5t930ixr9sbmce4emc` FOREIGN KEY (`channel_id`) REFERENCES `channel` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of subscriber_channel
-- ----------------------------

-- ----------------------------
-- Table structure for tag
-- ----------------------------
DROP TABLE IF EXISTS `tag`;
CREATE TABLE `tag` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `create_date` datetime DEFAULT NULL,
  `description` varchar(2000) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `status` varchar(255) NOT NULL,
  `type` varchar(255) DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `version` bigint(20) NOT NULL,
  `creator` varchar(50) DEFAULT NULL,
  `updater` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKsdh3v54p1msej7wtg78h7eshr` (`creator`),
  KEY `FKi4npd45cw71dbvi0dras60x05` (`updater`),
  CONSTRAINT `FKi4npd45cw71dbvi0dras60x05` FOREIGN KEY (`updater`) REFERENCES `users` (`username`),
  CONSTRAINT `FKsdh3v54p1msej7wtg78h7eshr` FOREIGN KEY (`creator`) REFERENCES `users` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of tag
-- ----------------------------

-- ----------------------------
-- Table structure for tag_blog
-- ----------------------------
DROP TABLE IF EXISTS `tag_blog`;
CREATE TABLE `tag_blog` (
  `tag_id` bigint(20) NOT NULL,
  `blog_id` bigint(20) NOT NULL,
  PRIMARY KEY (`tag_id`,`blog_id`),
  KEY `FKqxhibk47tjjwlr8058hakdiuy` (`blog_id`),
  CONSTRAINT `FKjamemtnfspljil86ji82bc0k4` FOREIGN KEY (`tag_id`) REFERENCES `tag` (`id`),
  CONSTRAINT `FKqxhibk47tjjwlr8058hakdiuy` FOREIGN KEY (`blog_id`) REFERENCES `blog` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of tag_blog
-- ----------------------------

-- ----------------------------
-- Table structure for todo
-- ----------------------------
DROP TABLE IF EXISTS `todo`;
CREATE TABLE `todo` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `content` longtext,
  `create_date` datetime DEFAULT NULL,
  `priority` varchar(255) NOT NULL,
  `sort_index` bigint(20) DEFAULT NULL,
  `status` varchar(255) NOT NULL,
  `title` varchar(2000) DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `version` bigint(20) NOT NULL,
  `creator` varchar(50) DEFAULT NULL,
  `updater` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK3iwg0iaj38jcjoi276tnogu2a` (`creator`),
  KEY `FK6701ir0uxybpnul7t9h1tn9ud` (`updater`),
  CONSTRAINT `FK3iwg0iaj38jcjoi276tnogu2a` FOREIGN KEY (`creator`) REFERENCES `users` (`username`),
  CONSTRAINT `FK6701ir0uxybpnul7t9h1tn9ud` FOREIGN KEY (`updater`) REFERENCES `users` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of todo
-- ----------------------------

-- ----------------------------
-- Table structure for translate
-- ----------------------------
DROP TABLE IF EXISTS `translate`;
CREATE TABLE `translate` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `create_date` datetime DEFAULT NULL,
  `creator` varchar(255) NOT NULL,
  `description` varchar(2000) DEFAULT NULL,
  `_key` varchar(255) NOT NULL,
  `search` longtext,
  `status` varchar(255) NOT NULL,
  `translate_date` datetime DEFAULT NULL,
  `translator` varchar(255) DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `updater` varchar(255) DEFAULT NULL,
  `version` bigint(20) NOT NULL,
  `project_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKq9t4skde82mism7nx8jye13eb` (`project_id`),
  CONSTRAINT `FKq9t4skde82mism7nx8jye13eb` FOREIGN KEY (`project_id`) REFERENCES `project` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of translate
-- ----------------------------

-- ----------------------------
-- Table structure for translate_item
-- ----------------------------
DROP TABLE IF EXISTS `translate_item`;
CREATE TABLE `translate_item` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `content` longtext,
  `create_date` datetime DEFAULT NULL,
  `creator` varchar(255) DEFAULT NULL,
  `status` varchar(255) NOT NULL,
  `translate_date` datetime DEFAULT NULL,
  `translator` varchar(255) DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `updater` varchar(255) DEFAULT NULL,
  `version` bigint(20) NOT NULL,
  `language_id` bigint(20) DEFAULT NULL,
  `translate_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKnnwofdgnp15t0sqw76a73qsq3` (`language_id`),
  KEY `FKr8fq1juryti7ltr7riw32lwh8` (`translate_id`),
  CONSTRAINT `FKnnwofdgnp15t0sqw76a73qsq3` FOREIGN KEY (`language_id`) REFERENCES `language` (`id`),
  CONSTRAINT `FKr8fq1juryti7ltr7riw32lwh8` FOREIGN KEY (`translate_id`) REFERENCES `translate` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of translate_item
-- ----------------------------

-- ----------------------------
-- Table structure for translate_item_history
-- ----------------------------
DROP TABLE IF EXISTS `translate_item_history`;
CREATE TABLE `translate_item_history` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `create_date` datetime DEFAULT NULL,
  `creator` varchar(255) DEFAULT NULL,
  `item_content` longtext,
  `item_create_date` datetime DEFAULT NULL,
  `item_creator` varchar(255) DEFAULT NULL,
  `status` varchar(255) NOT NULL,
  `version` bigint(20) NOT NULL,
  `translate_item_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKm7jepiljmbrlha2ycbrpcy1ey` (`translate_item_id`),
  CONSTRAINT `FKm7jepiljmbrlha2ycbrpcy1ey` FOREIGN KEY (`translate_item_id`) REFERENCES `translate_item` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of translate_item_history
-- ----------------------------

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `username` varchar(50) NOT NULL,
  `create_date` datetime DEFAULT NULL,
  `creator` varchar(255) DEFAULT NULL,
  `enabled` bit(1) NOT NULL,
  `hobby` varchar(255) DEFAULT NULL,
  `introduce` varchar(255) DEFAULT NULL,
  `last_login_date` datetime DEFAULT NULL,
  `level` varchar(255) DEFAULT NULL,
  `locked` bit(1) DEFAULT NULL,
  `login_count` bigint(20) NOT NULL,
  `login_remote_address` varchar(255) DEFAULT NULL,
  `mails` varchar(255) DEFAULT NULL,
  `mobile` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `place` varchar(255) DEFAULT NULL,
  `reset_pwd_date` datetime DEFAULT NULL,
  `reset_pwd_token` varchar(255) DEFAULT NULL,
  `status` varchar(255) NOT NULL,
  `version` bigint(20) NOT NULL,
  PRIMARY KEY (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES ('smallcc', '2018-12-26 10:42:07', 'smallcc', '', null, null, '2018-12-26 10:42:57', null, null, '1', '127.0.0.1', '1394807086@qq.com', null, 'smallcc', '$2a$10$hi.hXOYqxQJMT7Up3fnHqOCKAs0Xrn86rCpdRqkYWNpM4J9eEz.Nq', null, null, '2018-12-26 10:42:29', '', 'New', '3');
INSERT INTO `users` VALUES ('super', '2018-12-26 10:37:07', null, '', null, null, '2018-12-26 10:37:59', null, null, '1', '0:0:0:0:0:0:0:1', 'super@tms.com', null, '系统管理员', '$2a$10$srkAJfcBUznxueAs4G0mKuSpUTwDhT4ZXIkeZ9xXXWzm5R/BHTFYe', null, null, null, null, 'Bultin', '2');

-- ----------------------------
-- Table structure for user_project
-- ----------------------------
DROP TABLE IF EXISTS `user_project`;
CREATE TABLE `user_project` (
  `user_id` varchar(50) NOT NULL,
  `project_id` bigint(20) NOT NULL,
  PRIMARY KEY (`user_id`,`project_id`),
  KEY `FKocfkr6u2yh3w1qmybs8vxuv1c` (`project_id`),
  CONSTRAINT `FKjoreo8pojddvrp3cr4x8b610b` FOREIGN KEY (`user_id`) REFERENCES `users` (`username`),
  CONSTRAINT `FKocfkr6u2yh3w1qmybs8vxuv1c` FOREIGN KEY (`project_id`) REFERENCES `project` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of user_project
-- ----------------------------

-- ----------------------------
-- Table structure for voter_chat
-- ----------------------------
DROP TABLE IF EXISTS `voter_chat`;
CREATE TABLE `voter_chat` (
  `user_id` varchar(50) NOT NULL,
  `chat_id` bigint(20) NOT NULL,
  PRIMARY KEY (`user_id`,`chat_id`),
  KEY `FKb1vgbmbkqtemyapht30fxgym9` (`chat_id`),
  CONSTRAINT `FKb1vgbmbkqtemyapht30fxgym9` FOREIGN KEY (`chat_id`) REFERENCES `chat` (`id`),
  CONSTRAINT `FKr3tlvwds7nfj4jgv8cmlhi9e3` FOREIGN KEY (`user_id`) REFERENCES `users` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of voter_chat
-- ----------------------------

-- ----------------------------
-- Table structure for voter_chat_label
-- ----------------------------
DROP TABLE IF EXISTS `voter_chat_label`;
CREATE TABLE `voter_chat_label` (
  `user_id` varchar(50) NOT NULL,
  `chat_label_id` bigint(20) NOT NULL,
  PRIMARY KEY (`user_id`,`chat_label_id`),
  KEY `FKq5s5j1haxd8lkmq3nvaxglmmv` (`chat_label_id`),
  CONSTRAINT `FK3kv6tes8j5d3spf9vq2qrvvfg` FOREIGN KEY (`user_id`) REFERENCES `users` (`username`),
  CONSTRAINT `FKq5s5j1haxd8lkmq3nvaxglmmv` FOREIGN KEY (`chat_label_id`) REFERENCES `chat_label` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of voter_chat_label
-- ----------------------------

-- ----------------------------
-- Table structure for watcher_project
-- ----------------------------
DROP TABLE IF EXISTS `watcher_project`;
CREATE TABLE `watcher_project` (
  `user_id` varchar(50) NOT NULL,
  `project_id` bigint(20) NOT NULL,
  PRIMARY KEY (`user_id`,`project_id`),
  KEY `FKgx0fcj6ei9paa0507n0p4enyf` (`project_id`),
  CONSTRAINT `FKecia3cc9khr9gsu2wbpmbkdna` FOREIGN KEY (`user_id`) REFERENCES `users` (`username`),
  CONSTRAINT `FKgx0fcj6ei9paa0507n0p4enyf` FOREIGN KEY (`project_id`) REFERENCES `project` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of watcher_project
-- ----------------------------

-- ----------------------------
-- Table structure for watcher_translate
-- ----------------------------
DROP TABLE IF EXISTS `watcher_translate`;
CREATE TABLE `watcher_translate` (
  `user_id` varchar(50) NOT NULL,
  `translate_id` bigint(20) NOT NULL,
  PRIMARY KEY (`user_id`,`translate_id`),
  KEY `FKrhqxj20da52rhmr0630m8lkjo` (`translate_id`),
  CONSTRAINT `FKo8sdjkemqrttryl8av6ar0dsi` FOREIGN KEY (`user_id`) REFERENCES `users` (`username`),
  CONSTRAINT `FKrhqxj20da52rhmr0630m8lkjo` FOREIGN KEY (`translate_id`) REFERENCES `translate` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of watcher_translate
-- ----------------------------
