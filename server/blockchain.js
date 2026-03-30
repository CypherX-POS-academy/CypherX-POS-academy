const { Connection, Keypair, Transaction, PublicKey, TransactionInstruction, clusterApiUrl } = require('@solana/web3.js');

// ⚠️ 실제 서비스에서는 .env에 저장하거나 사용자의 지갑을 연동해야 합니다.
// 해커톤 용도로 단순 테스트를 위해 임의의 키페어를 생성하여 진행합니다. (Airdrop 필요)
// 매번 서버를 재시작할 때마다 키가 바뀌므로, Faucet에서 토큰을 받아야 트랜잭션이 가능합니다.
// (실제 시연 시 이 부분을 고정된 키페어로 교체하면 좋습니다.)
const payer = Keypair.generate(); 
const connection = new Connection(clusterApiUrl('devnet'), 'confirmed');

async function sendTimestamp(data) {
    // 솔라나 표준 메모 프로그램 주소
    const memoProgramId = new PublicKey("MemoSq4gqAB2B6asCNQC7YvjgG3ZpzkZvBdh36G4J6B"); 
    
    // 블록체인에 기록할 텍스트(JSON) 구성
    const memoText = JSON.stringify({
        title: data.title,
        hash: data.hash,
        creator: data.creator,
        ts: Date.now()
    });

    const instruction = new TransactionInstruction({
        keys: [],
        programId: memoProgramId,
        data: Buffer.from(memoText), // 메모 내용 버퍼로 변환
    });

    const transaction = new Transaction().add(instruction);
    
    // 트랜잭션 전송
    // 주의: payer 지갑에 Devnet SOL이 없으면 전송 실패(잔액 부족)가 발생합니다.
    const signature = await connection.sendTransaction(transaction, [payer]);
    await connection.confirmTransaction(signature);
    
    return signature;
}

module.exports = { sendTimestamp, payer, connection };
