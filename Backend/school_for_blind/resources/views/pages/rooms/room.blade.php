@extends('layouts.app')

@section('content')
    <meta name="csrf-token" content="{{ csrf_token() }}">

    <div class="container-fluid" dir="rtl">
        <div class="custom-card p-4">
            <div class="d-flex justify-content-between align-items-center mb-4"
                style="border-bottom: 1px solid var(--border-color); padding-bottom: 15px;">
                <h2 class="mb-0" style="color: var(--text-main);">
                    🎙️ غرفة: {{ $room_name }}
                </h2>
                <span id="connection-status" class="badge-status bg-soft-warning">جاري الاتصال...</span>
            </div>

            <div class="d-flex gap-3 mb-5">
                <button id="mute-btn" class="btn px-4 py-2"
                    style="display: none; background-color: var(--nav-active-bg); color: var(--text-main); border: 1px solid var(--border-color); border-radius: 8px;">
                    🔇 كتم المايك
                </button>
                <button id="leave-btn" class="btn px-4 py-2"
                    style="display: none; background-color: var(--nav-active-bg); color: var(--text-main); border: 1px solid var(--border-color); border-radius: 8px;">
                    🚪 خروج من المكالمة
                </button>
                <button id="end-call-btn" class="btn btn-danger px-4 py-2" style="display: none; border-radius: 8px;">
                    🛑 إنهاء المكالمة للجميع
                </button>
            </div>

            <div>
                <h4 style="color: var(--text-muted); margin-bottom: 15px;">👥 المتواجدون الآن:</h4>
                <ul id="participants-list"
                    style="list-style: none; padding: 0; display: flex; flex-direction: column; gap: 10px;">
                </ul>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/livekit-client/dist/livekit-client.umd.min.js"></script>

    <script>
        const livekitUrl = '{{ config("livekit.web_url") }}';
        const token = '{{ $token }}';
        const currentRoomName = '{{ $room_name }}';
        const dbMutedParticipants = @json($mutedParticipants ?? []); // جلب المكتومين من الداتا بيز مع حماية

        const room = new LivekitClient.Room();

        const muteBtn = document.getElementById('mute-btn');
        const leaveBtn = document.getElementById('leave-btn');
        const endCallBtn = document.getElementById('end-call-btn');
        const participantsList = document.getElementById('participants-list');
        const connectionStatus = document.getElementById('connection-status');

        let isMuted = false;

        // --- إعدادات الـ CSRF لطلبات الإدارة ---
        const csrfToken = document.querySelector('meta[name="csrf-token"]').content;
        const fetchHeaders = {
            "Content-Type": "application/json",
            "X-CSRF-TOKEN": csrfToken
        };

        // دالة الانضمام التلقائي
        async function connectToRoom() {
            try {
                // 1. الاتصال بالغرفة أولاً (بدون مايك)
                await room.connect(livekitUrl, token);
                console.log("رابط LiveKit المستخدم هو: ", livekitUrl);

                connectionStatus.innerText = 'متصل الآن';
                connectionStatus.className = 'badge bg-success text-white px-2 py-1 rounded';

                // إظهار أزرار التحكم
                muteBtn.style.display = 'inline-block';
                leaveBtn.style.display = 'inline-block';
                endCallBtn.style.display = 'inline-block';

                // 2. إضافة نفسك للقائمة
                addParticipantToList(room.localParticipant.identity, 'أنت (المدير)', true);

                // 3. جلب وإضافة الأشخاص الموجودين مسبقاً بالغرفة
                room.remoteParticipants.forEach((participant) => {
                    let audioTrackSid = '';

                    if (participant.audioTrackPublications) {
                        participant.audioTrackPublications.forEach((pub) => {
                            if (pub.kind === 'audio') {
                                audioTrackSid = pub.trackSid; // لقطنا الـ trackSid
                                if (pub.track) attachAudioTrack(pub.track, participant.identity);
                            }
                        });
                    }

                    // نمرر الـ audioTrackSid للزر
                    const displayName = participant.name || participant.identity;

                    // نمرر displayName بدلاً من تكرار participant.identity مرتين
                    addParticipantToList(participant.identity, displayName, false, audioTrackSid);
                });

                // 4. محاولة تشغيل المايك التلقائي
                try {
                    await room.localParticipant.setMicrophoneEnabled(true);
                    isMuted = false;
                    muteBtn.innerText = '🔇 كتم المايك';
                    muteBtn.style.backgroundColor = 'var(--nav-active-bg)';
                    muteBtn.style.color = 'var(--text-main)';
                } catch (micError) {
                    console.warn("المتصفح منع تشغيل المايك التلقائي:", micError);
                    isMuted = true;
                    muteBtn.innerText = '🔊 تفعيل المايك';
                    muteBtn.style.backgroundColor = 'rgba(220, 53, 69, 0.1)';
                    muteBtn.style.color = '#dc3545';
                }

            } catch (error) {
                connectionStatus.innerText = 'فشل الاتصال';
                connectionStatus.className = 'badge bg-danger text-white px-2 py-1 rounded';
                console.error("خطأ في الاتصال الأساسي مع LiveKit:", error);
            }
        }

        // تشغيل الاتصال بمجرد تحميل الصفحة
        window.addEventListener('load', connectToRoom);

        // --- أزرار التحكم الخاصة بك (كمدير) ---
        muteBtn.onclick = async () => {
            isMuted = !isMuted;
            await room.localParticipant.setMicrophoneEnabled(!isMuted);

            if (isMuted) {
                muteBtn.innerText = '🔊 تفعيل المايك';
                muteBtn.style.backgroundColor = 'rgba(220, 53, 69, 0.1)';
                muteBtn.style.color = '#dc3545';
            } else {
                muteBtn.innerText = '🔇 كتم المايك';
                muteBtn.style.backgroundColor = 'var(--nav-active-bg)';
                muteBtn.style.color = 'var(--text-main)';
            }
        };

        leaveBtn.onclick = async () => {
            await room.disconnect();
            window.location.href = "{{ route('admin.active-calls') }}";
        };

        endCallBtn.onclick = async () => {
            if (confirm("هل أنت متأكد من إنهاء المكالمة للجميع؟ سيتم طرد جميع الطلاب وإغلاق الغرفة.")) {
                try {
                    const response = await fetch("{{ route('rooms.actions.end') }}", {
                        method: 'POST',
                        headers: fetchHeaders,
                        body: JSON.stringify({ room_name: currentRoomName })
                    });
                    if (response.ok) {
                        await room.disconnect();
                        window.location.href = "{{ route('admin.active-calls') }}";
                    } else {
                        alert("حدث خطأ أثناء إنهاء المكالمة.");
                    }
                } catch (error) {
                    console.error(error);
                }
            }
        };

        // --- الاستماع لأحداث الغرفة (دخول وخروج الطلاب) ---

        // عند دخول شخص جديد
        // عند دخول شخص جديد
        room.on('participantConnected', (participant) => {
            const displayName = participant.name || participant.identity;

            // وإذا حبيت تستخدم الميتا داتا (مثل الرتبة) فيك تجيبها هيك:
            // const meta = JSON.parse(participant.metadata || '{}');
            // const role = meta.role; // رح ترجعلك 'Teacher' أو 'Student'

            addParticipantToList(participant.identity, displayName, false);
        });

        // عند خروج شخص
        room.on('participantDisconnected', (participant) => {
            const li = document.getElementById(`participant-${participant.identity}`);
            if (li) li.remove();

            // إزالة الصوت الخاص به لتنظيف الـ DOM
            const oldAudio = document.getElementById(`audio-${participant.identity}`);
            if (oldAudio) oldAudio.remove();
        });

        // عند تفعيل المستخدم للمايك
        room.on('trackSubscribed', (track, publication, participant) => {
            if (track.kind === 'audio') {
                attachAudioTrack(track, participant.identity);

                // تحديث زر الكتم ليعرف الـ track_sid الجديد
                const toggleBtn = document.getElementById(`toggle-mute-btn-${participant.identity}`);
                if (toggleBtn) {
                    toggleBtn.setAttribute('onclick', `toggleMuteUser('${participant.identity}', '${track.sid}')`);
                }
            }
        });

        // عند إغلاق المستخدم للمايك
        room.on('trackUnsubscribed', (track, publication, participant) => {
            if (track.kind === 'audio') {
                track.detach();
                const oldAudio = document.getElementById(`audio-${participant.identity}`);
                if (oldAudio) oldAudio.remove();
            }
        });

        room.on('disconnected', () => {
            alert("تم إغلاق الغرفة.");
            window.location.href = "{{ route('admin.active-calls') }}";
        });

        // كشف المتحدثين النشطين
        room.on('activeSpeakersChanged', (speakers) => {
            // أولاً نلغي التوهج عن الجميع
            const allParticipants = document.querySelectorAll('#participants-list li');
            allParticipants.forEach(li => {
                li.style.boxShadow = 'none';
                li.style.borderColor = 'var(--border-color)';
            });

            // نضيء اللي عم يحكوا حالياً باللون الأخضر
            speakers.forEach(speaker => {
                const li = document.getElementById(`participant-${speaker.identity}`);
                if (li) {
                    li.style.boxShadow = '0 0 10px rgba(40, 167, 69, 0.5)'; // توهج أخضر
                    li.style.borderColor = '#28a745'; // إطار أخضر
                }
            });
        });

        // --- دوال مساعدة ---

        function attachAudioTrack(track, identity) {
            const audioElement = track.attach();
            audioElement.id = `audio-${identity}`;
            audioElement.style.display = 'none';
            document.body.appendChild(audioElement);
        }

        function addParticipantToList(identity, name, isLocal, trackSid = '') {
            if (document.getElementById(`participant-${identity}`)) return;

            const li = document.createElement('li');
            li.id = `participant-${identity}`;
            li.className = 'd-flex justify-content-between align-items-center shadow-sm transition-all';
            li.style.backgroundColor = 'var(--bg-main)';
            li.style.border = '1px solid var(--border-color)';
            li.style.borderRadius = '8px';
            li.style.padding = '12px 16px';
            li.style.transition = 'all 0.3s ease';

            let actionsHtml = '';
            if (!isLocal) {
                // فحص هل الشخص مكتوم مسبقاً في قاعدة البيانات؟
                const isAlreadyMuted = dbMutedParticipants.includes(identity);

                const btnColor = isAlreadyMuted ? '#6c757d' : 'var(--bs-primary, #0d6efd)';
                const btnText = isAlreadyMuted ? '🔊 إلغاء الكتم' : '🔇 كتم';
                const dataMuted = isAlreadyMuted ? 'true' : 'false';

                actionsHtml = `
                                        <div class="d-flex gap-2">
                                            <button id="toggle-mute-btn-${identity}" 
                                                    data-muted="${dataMuted}" 
                                                    onclick="toggleMuteUser('${identity}', '${trackSid}')" 
                                                    class="btn btn-sm text-white fw-bold" 
                                                    style="background-color: ${btnColor}; border: none;">
                                                ${btnText}
                                            </button>
                                            <button onclick="kickUser('${identity}')" class="btn btn-sm btn-danger fw-bold">⛔ طرد</button>
                                        </div>
                                    `;
            } else {
                actionsHtml = `<span class="badge bg-secondary">أنت</span>`;
            }

            li.innerHTML = `
                                    <div class="d-flex align-items-center gap-2">
                                        <i id="icon-${identity}" class="fa-solid fa-user-graduate" style="color: var(--accent-color);"></i>
                                        <span style="font-size: 1.1rem; color: var(--text-main); font-weight: 500;">${name}</span>
                                    </div>
                                    ${actionsHtml}
                                `;
            participantsList.appendChild(li);
        }

        // --- دوال الإدارة (إرسال الأوامر للكنترولر) ---

        async function kickUser(identity) {
            if (!confirm(`هل تريد بالتأكيد طرد ${identity} من المكالمة؟`)) return;
            try {
                const response = await fetch("{{ route('rooms.actions.kick') }}", {
                    method: 'POST',
                    headers: fetchHeaders,
                    body: JSON.stringify({ room_name: currentRoomName, target_identity: identity })
                });
                const data = await response.json();
                if (data.success) {
                    console.log("تم إرسال أمر الطرد بنجاح");
                } else {
                    alert("خطأ: " + data.message);
                }
            } catch (error) {
                console.error(error);
            }
        }

        async function toggleMuteUser(identity, trackSid) {
            const btn = document.getElementById(`toggle-mute-btn-${identity}`);
            const isMuted = btn.getAttribute('data-muted') === 'true';

            if (!isMuted) {
                // إرسال أمر الكتم
                try {
                    const response = await fetch("{{ route('rooms.actions.mute') }}", {
                        method: 'POST',
                        headers: fetchHeaders,
                        body: JSON.stringify({ room_name: currentRoomName, target_identity: identity, track_sid: trackSid || '' })
                    });

                    if (response.ok) {
                        btn.setAttribute('data-muted', 'true');
                        btn.innerHTML = '🔊 إلغاء الكتم';
                        btn.style.backgroundColor = '#6c757d';
                    } else {
                        alert("حدث خطأ أثناء محاولة الكتم.");
                    }
                } catch (error) { console.error(error); }

            } else {
                // إرسال أمر فك الكتم
                try {
                    const response = await fetch("{{ route('rooms.actions.unmute') }}", {
                        method: 'POST',
                        headers: fetchHeaders,
                        body: JSON.stringify({ room_name: currentRoomName, target_identity: identity })
                    });

                    if (response.ok) {
                        btn.setAttribute('data-muted', 'false');
                        btn.innerHTML = '🔇 كتم';
                        btn.style.backgroundColor = 'var(--bs-primary, #0d6efd)';
                    } else {
                        alert("حدث خطأ أثناء محاولة فك الكتم.");
                    }
                } catch (error) { console.error(error); }
            }
        }
    </script>
@endsection