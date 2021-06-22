import React from 'react'

export default function Header({signers, quorum}) {
    return (
        <div>
            <p><b>Quorum</b>: {quorum}</p>
            <div>
                <h3>Signers</h3>
                <ul>
                    {signers.map(signer => <li key={signer}>{signer}</li>)}
                </ul>
            </div>
        </div>
    )
}
