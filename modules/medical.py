from __future__ import annotations
from datetime import datetime
import json

class MedicalRecordPatient:
    def __init__(self, first_name: str | None, last_name: str | None, nhs_number: str | None, date_of_birth: str | None):
        self.first_name = first_name
        self.last_name = last_name
        self.nhs_number = nhs_number
        self.date_of_birth = date_of_birth

    first_name: str | None
    last_name: str | None
    nhs_number: str | None
    date_of_birth: str | None

    def to_json(self):
        return {
            'first_name': self.first_name,
            'last_name': self.last_name,
            'nhs_number': self.nhs_number,
            'date_of_birth': self.date_of_birth
        }
    
    def compare_accuracy(self, actual: MedicalRecordPatient | None):
        accuracy = {
            'first_name': 0,
            'last_name': 0,
            'nhs_number': 0,
            'date_of_birth': 0
        }

        if actual is None:
            return accuracy
        
        accuracy['first_name'] = 1 if self.first_name == actual.first_name else 0
        accuracy['last_name'] = 1 if self.last_name == actual.last_name else 0
        accuracy['nhs_number'] = 1 if self.nhs_number == actual.nhs_number else 0
        accuracy['date_of_birth'] = 1 if self.date_of_birth == actual.date_of_birth else 0
        accuracy['overall'] = sum(accuracy.values()) / len(accuracy)

        return accuracy
    
class MedicalRecordReferral:
    def __init__(self, referred_by: str | None, referral_date: str | None, notes_summary: str | None):
        self.referred_by = referred_by
        self.referral_date = referral_date
        self.notes_summary = notes_summary

    notes_summary: str | None
    referred_by: str | None
    referral_date: str | None

    def to_json(self):
        return {
            'referred_by': self.referred_by,
            'referral_date': self.referral_date,
            'notes_summary': self.notes_summary
        }
    
    def compare_accuracy(self, actual: MedicalRecordReferral | None):
        accuracy = {
            'referred_by': 0,
            'referral_date': 0
        }

        if actual is None:
            return accuracy
        
        accuracy['referred_by'] = 1 if self.referred_by == actual.referred_by else 0
        accuracy['referral_date'] = 1 if self.referral_date == actual.referral_date else 0
        accuracy['overall'] = sum(accuracy.values()) / len(accuracy)

        return accuracy
    
class MedicalRecord:
    def __init__(self, patient_details: MedicalRecordPatient | None, referrals: list[MedicalRecordReferral] | None):
        self.patient_details = patient_details
        self.referrals = referrals
    
    patient_details: MedicalRecordPatient | None
    referrals: list[MedicalRecordReferral] | None

    @staticmethod
    def from_json_str(json_content_str: str):
        json_content = json.loads(json_content_str)
        details = json_content.get('patient_details', None)
        referrals = json_content.get('referrals', [])

        patient_details = MedicalRecordPatient(
            first_name=details.get('first_name', None),
            last_name=details.get('last_name', None),
            nhs_number=details.get('nhs_number', None),
            date_of_birth=details.get('date_of_birth', None)
        )

        patient_referrals = []
        for referral in referrals:
            patient_referrals.append(
                MedicalRecordReferral(
                    referred_by=referral.get('referred_by', None),
                    referral_date=referral.get('referral_date', None),
                    notes_summary=referral.get('notes_summary', None)
                )
            )

        return MedicalRecord(
            patient_details=patient_details, 
            referrals=patient_referrals
        )
    
    @staticmethod
    def empty():
        patient_details = MedicalRecordPatient(
            first_name='',
            last_name='',
            nhs_number='123 456 7890',
            date_of_birth=datetime.now().strftime('%Y-%m-%d')
        )

        patient_referral = MedicalRecordReferral(
            referred_by='',
            referral_date=datetime.now().strftime('%Y-%m-%d'),
            notes_summary=''
        )

        return MedicalRecord(
            patient_details=patient_details,
            referrals=[patient_referral]
        )
    
    @staticmethod
    def empty_json_str():
        empty_record = MedicalRecord.empty()
        return json.dumps(empty_record.to_json())
    
    def to_json(self):
        referrals = []
        if self.referrals is not None:
            for referral in self.referrals:
                if isinstance(referral, MedicalRecordReferral):
                    referrals.append(referral.to_json())
                else:
                    print('Referrals: Expected MedicalRecordReferral, got: ', type(referral))

        return {
            'patient_details': self.patient_details.to_json(),
            'referrals': referrals
        }
    
    def compare_accuracy(self, actual: MedicalRecord | None):
        accuracy = {
            'patient_details': {},
            'referrals': [],
            'referrals_overall': 0
        }

        if actual is None:
            return accuracy

        accuracy['patient_details'] = self.patient_details.compare_accuracy(actual.patient_details)

        if actual.referrals is None:
            accuracy['referrals_overall'] = 1 if self.referrals is None else 0
        else:
            if self.referrals is None:
                accuracy['referrals_overall'] = 0
            else:
                for actual_referral in actual.referrals:
                    expected_referral = next((referral for referral in self.referrals if referral.referral_date == actual_referral.referral_date), None)
                    if expected_referral is not None:
                        accuracy['referrals'].append(expected_referral.compare_accuracy(actual_referral))
                    else:
                        accuracy['referrals'].append({'overall': 0})

                num_referrals = len(accuracy['referrals']) if len(accuracy['referrals']) > 0 else 1
                accuracy['referrals_overall'] = sum([referral['overall'] for referral in accuracy['referrals']]) / num_referrals

        accuracy['overall'] = (accuracy['patient_details']['overall'] + accuracy['referrals_overall']) / 2
        
        return accuracy