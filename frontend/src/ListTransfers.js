import React from 'react'

export default function ListTransfers({transfers, quorum, confirmTransfer}) {
    return transfers.length === 0 ?
    <div>There are currently no transfers</div>:
    (
        <div>
            <table>
                <thead>
                    <th>ID</th>
                    <th>Amount</th>
                    <th>Recepient</th>
                    <th>Comfirmation Count</th>
                    <th>Sent</th>
                </thead>
                <tbody>
                    {transfers.map(({id, amount, to, numConfirmations, sent}) => (
                        <tr>
                            <td>{id}</td>
                            <td>{amount}</td>
                            <td>{to}</td>
                            <td>
                                {`${numConfirmations} / ${quorum}`}
                                <button onClick={() => confirmTransfer(id)}>approve</button>
                            </td>
                            <td>sent: {sent}</td>
                        </tr>
                    ))}
                </tbody>
            </table>
        </div>
    )
}
