const express = require('express');
const crypto = require('crypto');
const fs = require('fs');
const path = require('path');
const cors = require('cors');
const multer = require('multer');
const { sendTimestamp, connection, payer } = require('./blockchain');

const app = express();
app.use(express.json());
app.use(cors());

const DB_PATH = './database.json';
const UPLOAD_DIR = './uploads/';

if (!fs.existsSync(UPLOAD_DIR)) {
    fs.mkdirSync(UPLOAD_DIR);
}

// Multer 설정 (임시 파일 저장용)
const storage = multer.diskStorage({
    destination: (req, file, cb) => cb(null, UPLOAD_DIR),
    filename: (req, file, cb) => cb(null, Date.now() + path.extname(file.originalname))
});
const upload = multer({ storage });

console.log(`Payer Public Key: ${payer.publicKey.toBase58()}`);
console.log(`Requesting Airdrop for payer...`);
connection.requestAirdrop(payer.publicKey, 1000000000) 
    .then(sig => connection.confirmTransaction(sig))
    .then(() => console.log('Airdrop successful! Server is ready to send TX on Devnet.'))
    .catch(e => console.log('Airdrop failed. We might hit rate limit, or not needed. Error:', e.message));

// 파일 자체를 받아서 서버에서 해싱
app.post('/api/choreography/upload', upload.single('videoFile'), async (req, res) => {
    try {
        const { title, description, creatorAddress } = req.body;
        const file = req.file;

        if (!title || !file) {
            return res.status(400).json({ error: "Missing title or videoFile" });
        }
        
        // 1. 실제 영상 파일(Buffer) 해시 계산 (실제 서비스에서는 Stream을 읽어 대용량 해싱 처리 필요)
        const fileBuffer = fs.readFileSync(file.path);
        const hash = crypto.createHash('sha256').update(fileBuffer).digest('hex');
        
        // 2. 솔라나 트랜잭션 전송
        const txId = await sendTimestamp({ title, hash, creator: creatorAddress || "user_wallet_123" });
        const explorerUrl = `https://explorer.solana.com/tx/${txId}?cluster=devnet`;

        const newEntry = { 
            id: txId, 
            title, 
            description, 
            videoUrl: file.filename, // 클라이언트에서는 더 이상 원격 URL이 아니라 자신이 보낸 파일명을 받게 됨
            hash, 
            explorerUrl, 
            createdAt: new Date().toISOString() 
        };
        
        // 3. 간이 오프체인 DB 저장
        const db = JSON.parse(fs.readFileSync(DB_PATH, 'utf8') || '[]');
        db.push(newEntry);
        fs.writeFileSync(DB_PATH, JSON.stringify(db));

        // 공간 절약을 위해 임시 처리 후 파일 삭제 (MVP 용도)
        fs.unlinkSync(file.path);

        res.json({ success: true, txId, explorerUrl });
    } catch (error) {
        console.error("Upload error:", error);
        res.status(500).json({ error: error.message });
    }
});

// 안무 리스트 전체 조회
app.get('/api/choreography/list', (req, res) => {
    try {
        const db = JSON.parse(fs.readFileSync(DB_PATH, 'utf8') || '[]');
        res.json(db);
    } catch(error) {
        res.status(500).json({ error: error.message });
    }
});

const PORT = 3000;
app.listen(PORT, '0.0.0.0', () => {
    console.log(`Server running on http://0.0.0.0:${PORT}`);
});
